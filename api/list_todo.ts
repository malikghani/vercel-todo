// api/list_todo.ts
import type { VercelRequest, VercelResponse } from '@vercel/node'
import { supabase } from '../lib/supabase'

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET'])
    res.status(405).json({ error: `Method ${req.method} Not Allowed` })
    return
  }

  const { data, error } = await supabase
    .from('todos')
    .select('name')

  if (error) {
    res.status(500).json({ error: error.message })
    return
  }

  res.status(200).json({ todos: data })
}
