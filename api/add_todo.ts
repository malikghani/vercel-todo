// api/add_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'

export default function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', ['POST'])
    res.status(405).json({ error: `Method ${req.method} Not Allowed` })
    return
  }

  const { name } = req.body
  if (!name) {
    res.status(400).json({ error: 'Missing `name` in request body' })
    return
  }

  res.status(200).json({ name })
}
