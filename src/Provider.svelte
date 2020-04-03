<script>
  
//   const client = new ApolloClient({ uri: "..." });
//   setClient(client);

//   import { getClient, query } from 'svelte-apollo'; 
//   import { GET_BOOKS } from './queries';

//   // 2. Get the Apollo client from context
//   const client = getClient();

//   // 3. Execute the GET_BOOKS graphql query using the Apollo client
//   //    -> Returns a svelte store of promises that resolve as values come in
//   const data = query(client, { query: GET_BOOKS });
</script>

<slot data={{}} />
