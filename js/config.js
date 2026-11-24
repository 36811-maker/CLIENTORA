/* Configure o projeto Supabase em Project Settings > API.
   Enquanto as credenciais estiverem vazias, o CLIENTORA funciona em modo demonstração local. */
window.CLIENTORA_CONFIG = { SUPABASE_URL: "", SUPABASE_ANON_KEY: "" };
window.supabaseClient = null;
if (window.CLIENTORA_CONFIG.SUPABASE_URL && window.CLIENTORA_CONFIG.SUPABASE_ANON_KEY && window.supabase) {
  window.supabaseClient = window.supabase.createClient(window.CLIENTORA_CONFIG.SUPABASE_URL, window.CLIENTORA_CONFIG.SUPABASE_ANON_KEY);
}
