<script lang="ts">
  import { onMount } from 'svelte'
  import { fly, fade } from 'svelte/transition'
  let todos: string[] = []
  let newTodo = ''
  let error: string | null = null

  // API base path from environment (defaults to Vite proxy '/api')
  // API base path: use env var or default to production Vercel URL
  const api =
    import.meta.env.VITE_API_URL ||
    'https://todo-theta-lime.vercel.app/api'

  async function loadTodos() {
    try {
      const res = await fetch(`${api}/list_todo`)
      if (!res.ok) {
        const errText = await res.text()
        throw new Error(errText || res.statusText)
      }
      const data = await res.json()
      todos = Array.isArray(data.todos)
        ? data.todos.map((t: any) => t.name)
        : []
    } catch (e: any) {
      error = e.message
    }
  }

  async function addTodo() {
    if (!newTodo.trim()) return
    try {
      const res = await fetch(`${api}/add_todo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: newTodo })
      })
      if (!res.ok) {
        const errText = await res.text()
        throw new Error(errText || res.statusText)
      }
      newTodo = ''
      loadTodos()
    } catch (e: any) {
      error = e.message
    }
  }

  async function deleteTodo(name: string) {
    try {
      const res = await fetch(`${api}/delete_todo`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name })
      })
      if (!res.ok) {
        const errText = await res.text()
        throw new Error(errText || res.statusText)
      }
      loadTodos()
    } catch (e: any) {
      error = e.message
    }
  }

  onMount(loadTodos)
</script>

<main class="min-h-screen bg-gray-100 dark:bg-gray-900 p-6 flex items-start justify-center">
  <div in:fade={{ duration: 400 }} class="w-full max-w-md bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 space-y-4">
    <h1 class="text-3xl font-extrabold text-gray-800 dark:text-gray-100 text-center">
      Todo List
    </h1>
    <div class="flex mb-4 space-x-2">
    <input
      bind:value={newTodo}
      placeholder="New todo"
      class="flex-grow border border-gray-300 dark:border-gray-600 rounded-lg px-4 py-2 bg-gray-50 dark:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-400"
    />
    <button
      class="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-4 py-2 rounded-lg shadow"
      on:click={addTodo}
    >
      Add
    </button>
  </div>
    {#if error}
      <div class="text-red-600 bg-red-100 dark:bg-red-200 p-3 rounded">
        {error}
      </div>
    {/if}
</div>
  <ul class="mt-4 grid gap-3">
    {#each todos as todo (todo)}
      <li
        class="bg-gray-50 dark:bg-gray-700 rounded-lg shadow flex justify-between items-center px-4 py-2 hover:shadow-md transition-shadow"
        in:fly={{ y: 20, duration: 300 }}
        out:fly={{ y: -20, duration: 300 }}
      >
        <span class="text-gray-800 dark:text-gray-200">{todo}</span>
        <button
          class="text-red-500 hover:text-red-700 font-medium"
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
