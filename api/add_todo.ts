// api/add_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'
import { supabase } from '../lib/supabase.js'

export default async function handler(req: VercelRequest, res: VercelResponse) {
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

  const { error } = await supabase
    .from('todos')
    .insert([{ name }])

  if (error) {
    res.status(500).json({ error: error.message })
    return
  }

  res.status(200).json({ name })
}
