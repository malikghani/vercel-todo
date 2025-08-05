// lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = 'https://erljroubjknqplalateu.supabase.co'
const SUPABASE_ANON_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVybGpyb3ViamtucXBsYWxhdGV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzNzY2ODcsImV4cCI6MjA2OTk1MjY4N30.SVxvh32UY4wAp8Bb6051MfzRfRxfZc58OL_uBZzGPIw'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
