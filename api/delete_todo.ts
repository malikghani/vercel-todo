// api/delete_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'
import { deleteTodo } from '../lib/todos.js'

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'DELETE') {
    res.setHeader('Allow', ['DELETE'])
    res.status(405).json({ error: `Method ${req.method} Not Allowed` })
    return
  }

  const { name } = req.body
  if (!name) {
    res.status(400).json({ error: 'Missing `name` in request body' })
    return
  }

  const success = await deleteTodo(name)
  if (success) {
    res.status(200).json({ success: true })
  } else {
    res.status(404).json({ error: 'Todo not found' })
  }
}
