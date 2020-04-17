<script>
  import * as Pancake from "@sveltejs/pancake";
  import { getIssues } from "./data.js";
  import config from "../config.json";
  
  let orgrepo = config.repositories[0];
  let organization;
  let repository;

  $: [organization, repository] = orgrepo.split("/");

  const colors = {};

  let maxAge = 0;
  let labelAverageAges;
  let totalCount;
  let endCursor;
  let hasNextPage = true;

  $: loadIssues(organization, repository);

  async function loadIssues(organization, repository) {
    if (!organization || !repository) {
      return;
    }

    const result = await getIssues(organization, repository);
    const issues = result.edges;
    
    totalCount = result.totalCount;

    const labelAges = {};
    const now = Date.now();

    for (let i = 0; i < issues.length; i++) {
      const issue = issues[i];
      const { labels, createdAt } = issue.node;
      const age = now - new Date(createdAt).getTime();

      if (labels.nodes.length === 0) {
        addLabelAge("Unlabelled", age);
      } else {
        for (let j = 0; j < labels.nodes.length; j++) {
          const { name, color } = labels.nodes[j];

          addLabelAge(name, age);

          colors[name] = color;
        }
      }
    }

    maxAge = 0;

    labelAverageAges = Object.keys(labelAges)
      .map(label => {
        const ages = labelAges[label];
        const count = labelAges[label].length;
        const DAY_IN_MS = 1000 * 60 * 60 * 24;
        const sum = ages.reduce((total, value) => total + value, 0);
        const age = Math.round((10 * sum) / ages.length / DAY_IN_MS) / 10;

        if (age > maxAge) {
          maxAge = age;
        }

        return {
          label,
          age,
          count
        };
      })
      .sort((a, b) => {
        if (labelCategory(a.label) !== labelCategory(b.label)) {
          return a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1;
        }

        return b.age - a.age;
      });

    function labelCategory(label) {
      return label.split("/")[0];
    }

    function addLabelAge(name, age) {
      if (!(name in labelAges)) {
        labelAges[name] = [];
      }

      labelAges[name].push(age);
    }
  }

  // $: data.then(d => console.log(d));
</script>

<style>
  .axis {
    margin-bottom: 1em;
  }

  .bar {
    background: blue;
    display: inline-block;
    height: 1em;
  }

  td {
    width: 80vw;
    min-width: 400px;
  }

  .label {
    white-space: nowrap;
  }
</style>


<select bind:value={orgrepo}>
  {#each config.repositories as repo}
    <option value={repo}>{repo}</option>
  {/each}
</select>

{#if labelAverageAges}
  <p style="font-size: 8pt">
    This repository has a total of {totalCount} issues
  </p>
  <table>
    <thead>
      <tr>
        <th>Label</th>
        <th>
          <div class="axis">
            <Pancake.Chart x1={0} x2={maxAge / 0.9} y1={0} y2={0}>
              <Pancake.Grid vertical count={3} let:value>
                <span class="y label">{value} days</span>
              </Pancake.Grid>
            </Pancake.Chart>
          </div>
        </th>
      </tr>
    </thead>
    <tbody>
      {#each labelAverageAges as { label, age, count }}
        <tr>
          <th style="font-size: 9pt">{label}</th>
          <td style="font-size: 8pt">
            <span
              class="bar"
              style="width: {(90 * age) / maxAge}%; background-color: #{colors[label]}"
              title="{count} issues" />
            {age} days / {count} {#if count === 1}issue{:else}issues{/if}
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
{:else}
  <p>Loading...</p>
{/if}
