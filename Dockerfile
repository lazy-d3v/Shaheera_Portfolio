# ─── Stage 1: Build ───────────────────────────────────────────
FROM node:lts-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ─── Stage 2: Production ──────────────────────────────────────
FROM node:lts-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy only the built output — no source, no dev deps
COPY --from=builder /app/.output ./.output

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
