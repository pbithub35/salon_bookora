import { PrismaClient, UserRole, UserStatus, ShopStatus, ServiceMode } from '@prisma/client';
const prisma = new PrismaClient();

const DAY_OPEN = 600; // 10:00
const DAY_CLOSE = 1200; // 20:00

async function seedShop(userId: string, businessId: string, shop: {
  name: string; type: string; contact: string; address: string; city: string;
  state: string; pin: string; status: ShopStatus;
}) {
  const created = await prisma.shop.create({
    data: {
      businessId,
      name: shop.name,
      shopType: shop.type,
      contactNumber: shop.contact,
      addressLine1: shop.address,
      city: shop.city,
      state: shop.state,
      pincode: shop.pin,
      status: shop.status,
      bookingSlug: shop.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, ''),
      hours: {
        create: Array.from({ length: 7 }, (_, i) => ({
          dayOfWeek: i + 1,
          openMinutes: DAY_OPEN,
          closeMinutes: DAY_CLOSE,
          isClosed: i === 6,
        })),
      },
      bookingSettings: { create: {} },
      categories: {
        create: {
          name: 'Hair',
          sortOrder: 0,
          subcategories: {
            create: {
              name: 'Haircut',
              sortOrder: 0,
              services: {
                create: [
                  { name: "Men's Haircut", durationMinutes: 30, price: 299, mode: ServiceMode.BOTH },
                  { name: "Women's Haircut", durationMinutes: 45, price: 599, mode: ServiceMode.SALON },
                ],
              },
            },
          },
        },
      },
    },
  });
  // Owner is also a bookable staff member assigned to the shop.
  const staff = await prisma.staffMember.create({
    data: {
      businessId,
      userId,
      fullName: 'Owner',
      mobileNumber: shop.contact,
      isBookable: true,
    },
  });
  await prisma.shopStaffAssignment.create({
    data: { shopId: created.id, staffId: staff.id, role: 'OWNER' },
  });
}

const seeds = [
  { mobile: '9876543210', name: 'Aarav Sharma', city: 'Mohali', role: UserRole.CUSTOMER, status: UserStatus.ACTIVE },
  {
    mobile: '9876543220', name: 'Simran Kaur', city: 'Chandigarh', role: UserRole.SALON_OWNER, status: UserStatus.ACTIVE,
    brand: 'Glow Unisex Studio',
    shops: [{ name: 'Glow Unisex Studio, Mohali', type: 'Unisex Salon', contact: '9876543220', address: 'SCO 42, Sector 70', city: 'Mohali', state: 'Punjab', pin: '160071', status: ShopStatus.DRAFT }],
  },
  {
    mobile: '9876543230', name: 'Rajesh Verma', city: 'Ludhiana', role: UserRole.SALON_OWNER, status: UserStatus.ACTIVE,
    brand: 'The Royal Spa',
    shops: [
      { name: 'The Royal Spa, Ludhiana', type: 'Spa & Wellness', contact: '9876543230', address: 'Mall Road, Civil Lines', city: 'Ludhiana', state: 'Punjab', pin: '141001', status: ShopStatus.LIVE },
      { name: 'The Royal Spa, Delhi', type: 'Spa & Wellness', contact: '9876543230', address: '12 Rajpath, Connaught Place', city: 'Delhi', state: 'Delhi', pin: '110001', status: ShopStatus.DRAFT },
    ],
  },
  {
    mobile: '9876543240', name: 'Karan Mehra', city: 'Amritsar', role: UserRole.SALON_OWNER, status: UserStatus.ACTIVE,
    brand: null,
    shops: [],
  },
  { mobile: '9876543250', name: 'Restricted Account', city: 'Mohali', role: UserRole.CUSTOMER, status: UserStatus.SUSPENDED },
];

async function main() {
  for (const item of seeds) {
    const user = await prisma.user.upsert({
      where: { countryCode_mobileNumber: { countryCode: '+91', mobileNumber: item.mobile } },
      update: { fullName: item.name, city: item.city, role: item.role, status: item.status },
      create: { fullName: item.name, countryCode: '+91', mobileNumber: item.mobile, city: item.city, role: item.role, status: item.status },
    });
    if (item.role === UserRole.SALON_OWNER) {
      const business = await prisma.business.upsert({
        where: { ownerId: user.id },
        update: { brandName: item.brand ?? null },
        create: { ownerId: user.id, brandName: item.brand ?? null },
      });
      for (const shop of item.shops ?? []) {
        const existing = await prisma.shop.findFirst({ where: { businessId: business.id, name: shop.name } });
        if (!existing) await seedShop(user.id, business.id, shop);
      }
    }
  }
}

main().then(async () => { await prisma.$disconnect(); }).catch(async (error) => { console.error(error); await prisma.$disconnect(); process.exit(1); });
