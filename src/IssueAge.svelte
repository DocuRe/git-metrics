<script>
  import * as Pancake from "@sveltejs/pancake";
  import { query } from "svelte-apollo";
  import Router from "./Router.svelte";
  import { RECENT_ISSUES, client } from "./data.js";

  export let organization;
  export let repository;

  const colors = {};

  let maxAge = 0;
  let labelAverageAges;
  let totalCount;
  let cursor;

  $: loadIssues(organization, repository);

  function loadIssues(organization, repository) {
    if (!organization || !repository) {
      return;
    }

    query(client, {
      query: RECENT_ISSUES({ organization, repository })
    })
      .result()
      .then(result => {
        const issues = result.data.organization.repository.issues.edges;
        totalCount = result.data.organization.repository.issues.totalCount
        cursor = result.data.organization.repository.issues.pageInfo.endCursor
        console.log(cursor)
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
      });
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

{#if labelAverageAges}
<p style="font-size: 8pt">This reporitory has a total of {totalCount} issues</p>
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
          <th>{label}</th>
          <td style="font-size: 8pt">
            <span
              class="bar" 
              style="width: {(90 * age) / maxAge}%; background-color: #{colors[label]}"
              title="{count} issues" ></span>
            {age} days / {count} issue(s)
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
{:else}
  <p>Loading...</p>
{/if}
