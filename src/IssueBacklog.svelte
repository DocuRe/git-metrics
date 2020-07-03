<script>
  import * as Pancake from "@sveltejs/pancake";
  import { getIssues, getReleases } from "./data.js";
  import config from "../config.json";

  const DAY_IN_MS = 1000 * 60 * 60 * 24;

  let orgrepo = config.repositories[0];
  let organization;
  let repository;

  let points;
  let startTime;
  let now = Date.now();
  let max = 0;

  let releases;
  let showReleases = true;

  $: [organization, repository] = orgrepo.split("/");
  $: loadData(organization, repository);

  async function loadData(organization, repository) {
    if (!organization || !repository) {
      return;
    }

    const result = await getIssues(organization, repository);
    const issues = result.edges;

    startTime = getDateFromTime(new Date(issues[0].node.createdAt).getTime());
	max = 0;
	releases = null;

    const now = Date.now();
    points = [];

    for (let time = startTime; time <= now; time += DAY_IN_MS) {
      const count = getOpenIssueCount(issues, time);

      if (count > max) {
        max = count;
      }

      points.push({ x: time, y: count });
    }

    releases = await loadReleases(organization, repository);
  }

  async function loadReleases(organization, repository) {
    const { nodes } = await getReleases(organization, repository);

    return nodes
      .filter(({ name }) => !/-rc/.test(name))
      .map(({ name, publishedAt }) => {
        const time = getDateFromTime(new Date(publishedAt).getTime());

        return {
          x: time,
          y: points.find(({ x }) => x === time).y,
          title: name
        };
      });
  }

  function getDateFromTime(time) {
    return time - (time % DAY_IN_MS) + DAY_IN_MS;
  }

  function getOpenIssueCount(issues, time) {
    let count = 0;

    for (let issue of issues) {
      const { createdAt, closedAt } = issue.node;

      if (
        new Date(createdAt).getTime() <= time &&
        (!closedAt || new Date(closedAt).getTime() > time)
      ) {
        count++;
      }
    }
    return count;
  }
</script>

<style>
  .chart {
    height: 600px;
    padding: 3em 2em 2em 3em;
    box-sizing: border-box;
  }

  .axes {
    width: 100%;
    height: 100%;
    border-left: 1px solid black;
    border-bottom: 1px solid black;
  }

  .y.label {
    position: absolute;
    left: -2.5em;
    width: 2em;
    text-align: right;
    bottom: -0.5em;
  }

  .x.label {
    position: absolute;
    width: 4em;
    left: -2em;
    bottom: -22px;
    font-family: sans-serif;
    text-align: center;
  }

  .grid-line.horizontal {
    width: calc(100% + 2em);
    left: -2em;
    border-bottom: 1px dashed #ccc;
  }

  .grid-line.vertical {
    height: 100%;
    border-left: 1px dashed #ccc;
  }

  path.data {
    stroke: red;
    stroke-linejoin: round;
    stroke-linecap: round;
    stroke-width: 2px;
    fill: none;
  }

  path.release {
    stroke: black;
    stroke-linejoin: round;
    stroke-linecap: round;
    stroke-width: 15px;
    fill: none;
  }

  path.highlight {
    stroke: black;
    stroke-linejoin: round;
    stroke-linecap: round;
    stroke-width: 20px;
    fill: none;
  }
</style>

<select bind:value={orgrepo}>
  {#each config.repositories as repo}
    <option value={repo}>{repo}</option>
  {/each}
</select>

<p>
  <label>
    <input type="checkbox" bind:checked={showReleases} />
    Show Releases
  </label>
</p>

{#if points}
  <div class="chart">
    <Pancake.Chart x1={startTime} x2={now} y1={0} y2={max}>
      <Pancake.Box x2={10} y2={100}>
        <div class="axes" />
      </Pancake.Box>

      <Pancake.Grid vertical let:value>
        <div class="grid-line vertical" />
        <span class="x label">{new Date(value).toLocaleDateString()}</span>
      </Pancake.Grid>

      <Pancake.Grid horizontal count={10} let:value>
        <div class="grid-line horizontal" />
        <span class="y label">{value}</span>
      </Pancake.Grid>

      <Pancake.Svg>
        <Pancake.SvgLine data={points} let:d>
          <path class="data" {d} />
        </Pancake.SvgLine>

        {#if releases && showReleases}
          <Pancake.SvgScatterplot data={releases} let:d>
            <path class="release" {d} />
          </Pancake.SvgScatterplot>

          <Pancake.Quadtree
            data={releases}
            x={d => d.x}
            y={d => d.y}
            let:closest>
            {#if closest}
              <Pancake.SvgPoint x={closest.x} y={closest.y} let:d>
                <path class="highlight" {d}>
                  <title>{closest.title}</title>
                </path>
              </Pancake.SvgPoint>
            {/if}
          </Pancake.Quadtree>
        {/if}
      </Pancake.Svg>

    </Pancake.Chart>
  </div>
{:else}
  <p>Loading...</p>
{/if}
