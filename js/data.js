window.ClientoraData = (() => {
 const KEY='clientora_data_v1', SESSION='clientora_session';
 const seed={
  clients:[
   {id:'c1',name:'Mariana Costa',company:'Ateliê Costa',email:'mariana@exemplo.com',phone:'(11) 99999-1212',category:'Cliente ativo',status:'Ativo',owner:'Ana Martins',city:'São Paulo',created:Date.now()-86400000*12},
   {id:'c2',name:'Rafael Almeida',company:'Almeida Tech',email:'rafael@exemplo.com',phone:'(11) 98888-2323',category:'Cliente potencial',status:'Ativo',owner:'Lucas Lima',city:'Campinas',created:Date.now()-86400000*8},
   {id:'c3',name:'Camila Rocha',company:'Rocha Studio',email:'camila@exemplo.com',phone:'(19) 97777-3434',category:'Cliente ativo',status:'Ativo',owner:'Ana Martins',city:'Campinas',created:Date.now()-86400000*3}
  ],
  leads:[
   {id:'l1',name:'Bruno Ferreira',company:'BF Soluções',email:'bruno@exemplo.com',source:'Indicação',status:'Qualificado',owner:'Lucas Lima',priority:'Alta',created:Date.now()-86400000*2},
   {id:'l2',name:'Juliana Mendes',company:'JM Design',email:'juliana@exemplo.com',source:'Site',status:'Novo',owner:'Ana Martins',priority:'Média',created:Date.now()-86400000}
  ],
  opportunities:[
   {id:'o1',name:'Projeto de expansão',client:'Mariana Costa',value:18500,stage:'Proposta enviada',owner:'Ana Martins',probability:70,due:'2026-12-15',priority:'Alta'},
   {id:'o2',name:'Licença anual',client:'Rafael Almeida',value:9200,stage:'Negociação',owner:'Lucas Lima',probability:55,due:'2026-12-20',priority:'Média'},
   {id:'o3',name:'Pacote corporativo',client:'Camila Rocha',value:12400,stage:'Qualificação',owner:'Ana Martins',probability:35,due:'2026-12-28',priority:'Baixa'}
  ],
  tasks:[{id:'t1',title:'Retornar proposta para Mariana',status:'A fazer',priority:'Alta',owner:'Ana Martins',due:'2026-11-26'},{id:'t2',title:'Preparar apresentação comercial',status:'Em andamento',priority:'Média',owner:'Lucas Lima',due:'2026-11-28'}],
  appointments:[{id:'a1',title:'Reunião de alinhamento',date:'2026-11-26',time:'14:00',client:'Mariana Costa',owner:'Ana Martins'}],
  activities:[{id:'at1',type:'Ligação',description:'Primeiro contato realizado',client:'Mariana Costa',owner:'Ana Martins',date:new Date().toISOString().slice(0,10)}],
  teams:[{id:'tm1',name:'Comercial',manager:'Ana Martins',members:3}],
  users:[{id:'u1',name:'Ana Martins',email:'ana@clientora.demo',role:'Administrador',team:'Comercial'},{id:'u2',name:'Lucas Lima',email:'lucas@clientora.demo',role:'Vendedor',team:'Comercial'}],
  campaigns:[{id:'ca1',name:'Campanha de novembro',channel:'Redes sociais',status:'Ativa',leads:24,conversions:5}],
  notifications:[{id:'n1',title:'Bem-vindo ao CLIENTORA',description:'Explore os módulos e personalize seus registros.',read:false,date:new Date().toISOString()}],
  goals:[{id:'g1',name:'Meta de vendas mensal',target:50000,current:30100,period:'Mensal'}],
  logs:[]
 };
 let db;
 try{db=JSON.parse(localStorage.getItem(KEY))||seed; if(!db.clients)db=seed;}catch(e){db=seed;}
 const save=()=>localStorage.setItem(KEY,JSON.stringify(db));
 const all=table=>(db[table]||[]);
 const add=(table,item)=>{const row={...item,id:crypto.randomUUID?crypto.randomUUID():String(Date.now())};(db[table]||(db[table]=[])).unshift(row);log('Criou',table,row.id);save();return row;};
 const update=(table,id,patch)=>{const arr=all(table),i=arr.findIndex(x=>x.id===id);if(i<0)return null;arr[i]={...arr[i],...patch};log('Atualizou',table,id);save();return arr[i];};
 const remove=(table,id)=>{db[table]=all(table).filter(x=>x.id!==id);log('Removeu',table,id);save();};
 const log=(action,entity,record)=>{db.logs.unshift({id:String(Date.now()+Math.random()),action,entity,record,date:new Date().toISOString(),user:getSession()?.name||'Usuário demonstração'});};
 const getSession=()=>{try{return JSON.parse(localStorage.getItem(SESSION));}catch(e){return null;}};
 const setSession=user=>localStorage.setItem(SESSION,JSON.stringify(user));
 const logout=()=>localStorage.removeItem(SESSION);
 const reset=()=>{db=JSON.parse(JSON.stringify(seed));save();};
 save();
 return {all,add,update,remove,save,getSession,setSession,logout,reset};
})();
