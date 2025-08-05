// api/list_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'
import { listTodos } from '../lib/todos.js'

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET'])
    res.status(405).json({ error: `Method ${req.method} Not Allowed` })
    return
  }

  const todos = await listTodos()
  res.status(200).json({ todos })
}
