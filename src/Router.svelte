<script>
  //import Flare from "./Flare.svelte";
  import Router from "svelte-spa-router";
  import TriageCount from "./TriageCount.svelte";
  import TriageIssues from "./TriageIssues.svelte";
  import IssueAge from "./IssueAge.svelte";
  import IssueBacklog from './IssueBacklog.svelte';

  const routes = {
    '/issue': IssueAge,
    '/triage': TriageCount,
    '/backlog': IssueBacklog,
    '/triage-issues/:organization/:column/:label' : TriageIssues
  };
</script>

<nav>
  <a href="#/issue">Issue Age</a>
  |
  <a href="#/backlog">Issue Backlog</a>
  |
  <a href="#/triage">Triage Count</a>
</nav>

<Router {routes} />
