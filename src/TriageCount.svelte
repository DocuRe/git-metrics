<script>
  import * as Pancake from "@sveltejs/pancake";
  import { query } from "svelte-apollo";
  import Router from "./Router.svelte";
  import { TRIAG_PROJECT_ISSUES, client } from "./data.js";

  export let organization;

  const colors = {};

  let maxAge = 0;
  let labelAverageAges;
  let totalCount;
  let endCursor;
  let hasNextPage = true;

  $: loadIssues(organization);

  function loadIssues(organization) {
    if (!organization) {
      return;
    }
// console.log(RECENT_ISSUES({ organization, repository })) HOW CAN I GET THIS TO PRINT AS A STRING??
    query(client, {
      query: TRIAG_PROJECT_ISSUES({ organization })
    })
      .result()
      .then(result => {
        const projectColumns = result.data.organization.project.column.nodes;

        const labelAges = {};
        const now = Date.now();

        if (hasNextPage) {
          // recursively call a function until hasNextPage is false creating a masterResult object
        }
        for (let i = 0; i < projectColumns.length; i++) { //this loops over the columns returned
          const column = projectColumns[i];
          const colName = column.name;
          const totalCards = column.cards.totalCount;
          const cursor = column.cards.pageInfo.cursor;
          const hasNextPage = column.cards.pageInfo.hasNextPage;
          const issues = column.cards.nodes;
          
          for (let k = 0; k < issues; k++ ){  //this loops over the cards returned, each card is an issue
            const issue = issues[k];
            if (colName === 'To Do') {
              // group by issue.content.repository.nameWithOwner
              // group by issue.content.labels.nodes.name where name starts with area/ 
              // count the number of issues
              // create a bar graph that shows the count by area/...
            } else if (colName === 'Assigned to Area Owner For Triage') {
              // group by issue.content.repository.nameWithOwner
              // group by issue.content.labels.nodes.name where name starts with area/ 
              // count the number of issues
              // create a bar graph that shows the count by area/...              
            }
            const { labels, createdAt } = issue.content;
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
          <th style="font-size: 9pt">{label}</th>
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
