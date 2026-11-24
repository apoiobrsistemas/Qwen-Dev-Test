# Whatsapp-atendimento-ai

Sistema de Atendimento WhatsApp com **IA de Triagem (JSON Schema)**, **Painel Kanban em Tempo Real (WebSocket)**, **Lista da Vez (Round-Robin)** com lock distribuído no Redis, **ChatOps** em grupos, sincronização assíncrona com **Google Workspace** e camada obrigatória de proteção **Antibloqueio**.

## Estado Atual: `Fase 2 - Concluída e Validada (QA Aprovado)`

---

## Como Executar Localmente (Sem WhatsApp Conectado / Modo Mock)

### 1. Configurar Variáveis de Ambiente
```bash
cp infra/.env.example backend/.env
```
Por padrão, `infra/.env.example` já vem configurado com `DATABASE_URL=file:./dev.db`, `REDIS_URL=memory://` e `MOCK_MODE=true` para execução local imediata.

### 2. Iniciar o Backend
```bash
cd backend
npm install
npx prisma generate
npx prisma db push
npm run dev
```
O servidor sobe em `http://localhost:3001` (WebSocket em `ws://localhost:3001/ws`).

### 3. Iniciar o Frontend Kanban
```bash
cd frontend
npm install
npm run dev
```
Acesse o painel em `http://localhost:5173` e clique em **"Simular Webhook"** no Page Header para testar o fluxo completo em tempo real.

### 4. Executar Testes e Simulação Ponta a Ponta
```bash
cd backend
npm test
npx tsx tests/e2e-simulate.ts
```

### 5. Subir Stack Completa via Docker Compose (PostgreSQL + Redis + Evolution API)
```bash
cp infra/.env.example infra/.env
docker compose -f infra/docker-compose.yml up -d --build
```

---

## Governança e Contexto Vivo (`.antigravity/`)
- **Contexto Vivo:** `.antigravity/context/{PROJECT_CONTEXT,DESIGN_SYSTEM,ARCHITECTURE_DECISIONS,CHANGELOG_AI}.md`
- **Agentes:** `.antigravity/agents/` (`arquiteto-sistemas`, `dev-backend-api`, `dev-frontend-kanban`, `especialista-ia-triagem`, `qa-seguranca-antiblock`)
- **Skills:** `.antigravity/skills/` (`gestao-contexto-vivo`, `evolution-api-whatsapp`, `lista-da-vez-round-robin`, `google-workspace-sync`, `chatops-grupos`, `regras-antibloqueio`)
- **Workflows:** `.antigravity/workflows/` (`01-setup-infra` a `04-qa-e-validacao`)
