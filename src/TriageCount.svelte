<script>
  import * as Pancake from "@sveltejs/pancake";
  import Router from "./Router.svelte";
  import { getTriageProjectIssues } from "./data.js";
  import config from "../config.json";

  const organization = config.repositories[0].split("/")[0];

  const colors = {};

  let columns;

  $: loadIssues(organization);

  async function loadIssues(organization) {
    const projectColumns = await getTriageProjectIssues(organization);

    columns = projectColumns.map(({ name, cards }) => {
      const issues = cards.nodes;
      const groups = {};
      const totalCount = cards.totalCount;
      let maxCount = 0;

      for (let k = 0; k < issues.length; k++) {
        //this loops over the cards returned, each card is an issue
        const { labels } = issues[k].content;

        const areaLabels = labels.nodes.filter(({ name }) =>
          /^area\//.test(name)
        );

        if (areaLabels.length === 0) {
          const key = `Unknown`;
          groups[key] = (groups[key] || 0) + 1;
        } else {
          const { name, color } = areaLabels[0];
          groups[name] = (groups[name] || 0) + 1;
          colors[name] = color;
        }
      }

      const counts = Object.keys(groups)
        .map(label => {
          const count = groups[label];

          if (count > maxCount) {
            maxCount = count;
          }

          return { label, count };
        })
        .sort((a, b) => {
          return b.count - a.count;
        });

      return { maxCount, counts, name, totalCount };
    });
  }
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
    min-width: 200px;
    white-space: nowrap;
  }

  .label {
    white-space: nowrap;
  }

  .flex {
    display: flex;
  }
</style>

{#if columns}
  <div class="flex">
    {#each columns as { name, maxCount, counts, totalCount }}
      <div>
        <p style="font-size: 8pt; text-align: center">
          "{name}" has a total of {totalCount} issues
        </p>
        <table>
          <thead>
            <tr>
              <th>Label</th>
              <th>
                <div class="axis">
                  <Pancake.Chart x1={0} x2={maxCount / 0.9} y1={0} y2={0}>
                    <Pancake.Grid vertical count={3} let:value>
                      <span class="y label">{value}</span>
                    </Pancake.Grid>
                  </Pancake.Chart>
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            {#each counts as { repository, label, count }}
              <tr>
                <th style="font-size: 9pt">{label}</th>
                <td style="font-size: 8pt">
                  <span
                    class="bar"
                    style="width: {(90 * count) / maxCount}%; background-color:
                    #{colors[label]}"
                    title="{count} issues" />
                  {count}
                  {#if count === 1}issue{:else}issues{/if}
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    {/each}
  </div>
{:else}
  <p>Loading...</p>
{/if}
