<script>
  import { getTriageProjectIssues } from "./data.js";

  export let params = {};

  let issues;

  $: getData(
    decodeURIComponent(params.organization),
    decodeURIComponent(params.column),
    decodeURIComponent(params.label)
  );

  async function getData(organization, column, label) {
    const projectColumns = await getTriageProjectIssues(organization);

	const projectColumn = projectColumns.find(({ name }) => name === column);
	
    issues = projectColumn.cards.nodes.filter(issue => {
      const { labels } = issue.content;

      if (label === "Unknown") {
        const areaLabels = labels.nodes.filter(({ name }) =>
          /^area\//.test(name)
        );

        if (areaLabels.length === 0) {
          return true;
        }
      } else {
        return !!labels.nodes.find(({ name }) => label === name);
      }
    });
  }
</script>

{#if issues}
  <p>{issues.length} issues found:</p>
  {#each issues as { content: { title, url } }}
    <p>
      <a href={url} target="_blank">{title}</a>
    </p>
  {/each}
{/if}
