// api/delete_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'
import { supabase } from '../lib/supabase.js'

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

  const { data, error } = await supabase
    .from('todos')
    .delete()
    .eq('name', name)

  if (error) {
    res.status(500).json({ error: error.message })
    return
  }

  if (!Array.isArray(data) || data.length === 0) {
    res.status(404).json({ error: 'Todo not found' })
    return
  }

  res.status(200).json({ success: true })
}
