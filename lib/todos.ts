// lib/todos.ts
// File-based store for todos in /tmp (ephemeral but shared across function invocations on the same instance)
import fs from 'fs/promises'

const DATA_FILE = '/tmp/todos.json'

async function load(): Promise<string[]> {
  try {
    const data = await fs.readFile(DATA_FILE, 'utf8')
    return JSON.parse(data) as string[]
  } catch (err: any) {
    if (err.code === 'ENOENT') {
      return []
    }
    throw err
  }
}

async function save(todos: string[]): Promise<void> {
  await fs.writeFile(DATA_FILE, JSON.stringify(todos), 'utf8')
}

/**
 * Add a todo by name.
 */
export async function addTodo(name: string): Promise<void> {
  const todos = await load()
  todos.push(name)
  await save(todos)
}

/**
 * List all todos.
 */
export async function listTodos(): Promise<string[]> {
  return load()
}

/**
 * Delete a todo by name; returns true if deleted, false if not found.
 */
export async function deleteTodo(name: string): Promise<boolean> {
  const todos = await load()
  const idx = todos.indexOf(name)
  if (idx !== -1) {
    todos.splice(idx, 1)
    await save(todos)
    return true
  }
  return false
}
