<script lang="ts">
  import { onMount } from 'svelte'
  import { fly } from 'svelte/transition'
  let todos: string[] = []
  let newTodo = ''
  let error: string | null = null

  const api = '/api'

  async function loadTodos() {
    try {
      const res = await fetch(`${api}/list_todo`)
      const data = await res.json()
      todos = data.todos.map((t: any) => t.name)
    } catch (e: any) {
      error = e.message
    }
  }

  async function addTodo() {
    if (!newTodo.trim()) return
    try {
      await fetch(`${api}/add_todo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newTodo })
      })
      newTodo = ''
      loadTodos()
    } catch (e: any) {
      error = e.message
    }
  }

  async function deleteTodo(name: string) {
    try {
      await fetch(`${api}/delete_todo`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name })
      })
      loadTodos()
    } catch (e: any) {
      error = e.message
    }
  }

  onMount(loadTodos)
</script>

<main class="max-w-xl mx-auto p-4">
  <h1 class="text-2xl font-bold mb-4">Todo List</h1>
  <div class="flex mb-4">
    <input
      bind:value={newTodo}
      placeholder="New todo"
      class="flex-grow border rounded p-2 mr-2"
    />
    <button class="bg-blue-500 text-white px-4 rounded" on:click={addTodo}>
      Add
    </button>
  </div>
  {#if error}
    <div class="text-red-600 mb-4">{error}</div>
  {/if}
  <ul class="space-y-2">
    {#each todos as todo (todo)}
      <li
        class="flex justify-between items-center bg-gray-100 p-2 rounded transition transform hover:scale-105"
        in:fly={{ x: 200, duration: 300 }}
        out:fly={{ x: -200, duration: 300 }}
      >
        <span>{todo}</span>
        <button
          class="text-red-500"
          on:click={() => deleteTodo(todo)}
        >
          Delete
        </button>
      </li>
    {/each}
  </ul>
</main>

<style global>
  @import './app.css';
</style>
