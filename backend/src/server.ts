import app from './app';
import { env } from './config/env';
import { prisma } from './config/database';
const server = app.listen(env.PORT, () => console.log(`SalonBookora API listening on :${env.PORT}`));
async function shutdown() { server.close(async () => { await prisma.$disconnect(); process.exit(0); }); }
process.on('SIGINT', shutdown); process.on('SIGTERM', shutdown);
