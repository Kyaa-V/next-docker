# ======================
# Stage 1: Development
# ======================
FROM node:22-alpine AS development

WORKDIR /app

COPY package*.json ./

# Install semua dependen untuk dev
RUN npm ci

COPY . .

EXPOSE 3000
CMD ["npm", "run", "dev"]

# ======================
# Stage 2: Build
# ======================
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ======================
# Stage 3: Production
# ======================
FROM node:22-alpine AS production

WORKDIR /app

COPY package*.json ./

# Install hanya dependen produksi
RUN npm ci --omit=dev

# Copy hasil build dari stage build
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
