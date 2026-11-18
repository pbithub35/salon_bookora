import { Router } from 'express';
import { accountController } from '../controllers/account.controller';
import { authenticate, allowRoles, requireActive } from '../middleware/auth';
import { validate } from '../middleware/validate';
import { profileUpdateSchema } from '../validation/auth';

const router = Router();
router.use(authenticate);

router.get('/me', accountController.profile);
router.patch(
  '/me',
  requireActive,
  validate(profileUpdateSchema),
  accountController.update,
);
router.delete('/me', accountController.close);
router.get(
  '/business',
  allowRoles('SALON_OWNER'),
  accountController.profile,
);

export default router;
