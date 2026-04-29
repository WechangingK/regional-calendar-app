import pygame
import random
from settings import *
from bullet import Bullet


class Tank:
    """坦克基类"""
    def __init__(self, col, row, direction, color):
        self.col = col
        self.row = row
        self.direction = direction
        self.color = color
        self.speed = TANK_SPEED
        self.size = CELL - 6
        self.shoot_cooldown_timer = 0
        self.alive = True
        self._update_pixel_pos()

    def _update_pixel_pos(self):
        self.x = self.col * CELL + (CELL - self.size) // 2
        self.y = self.row * CELL + (CELL - self.size) // 2

    def _get_grid_pos(self):
        return (round((self.y + self.size // 2 - CELL // 2) / CELL),
                round((self.x + self.size // 2 - CELL // 2) / CELL))

    def draw(self, screen):
        cx = self.x + self.size // 2
        cy = self.y + self.size // 2
        r = pygame.Rect(self.x, self.y, self.size, self.size)
        pygame.draw.rect(screen, self.color, r, border_radius=4)

        # 炮管
        dx, dy = DIR_VECTORS[self.direction]
        barrel_len = self.size // 2 + 4
        end_x = cx + dx * barrel_len
        end_y = cy + dy * barrel_len
        pygame.draw.line(screen, self.color, (cx, cy), (end_x, end_y), 6)

    def shoot(self):
        if self.shoot_cooldown_timer > 0:
            return None
        self.shoot_cooldown_timer = SHOOT_COOLDOWN
        cx = self.x + self.size // 2
        cy = self.y + self.size // 2
        dx, dy = DIR_VECTORS[self.direction]
        return Bullet(cx + dx * (self.size // 2 + 6),
                      cy + dy * (self.size // 2 + 6),
                      self.direction,
                      'player' if isinstance(self, PlayerTank) else 'enemy')

    def update(self, dt):
        self.shoot_cooldown_timer = max(0, self.shoot_cooldown_timer - dt)

    def get_rect(self):
        return pygame.Rect(self.x, self.y, self.size, self.size)


class PlayerTank(Tank):
    def __init__(self, col, row):
        super().__init__(col, row, UP, YELLOW)
        self.speed = TANK_SPEED
        self.lives = PLAYER_LIVES
        self.respawn_timer = 0

    def handle_input(self, dt, keys, game_map, tanks):
        if not self.alive:
            return None

        moved = False
        dx, dy = 0, 0

        if keys[pygame.K_UP]:
            self.direction = UP
            dy = -self.speed * dt
            moved = True
        elif keys[pygame.K_DOWN]:
            self.direction = DOWN
            dy = self.speed * dt
            moved = True
        elif keys[pygame.K_LEFT]:
            self.direction = LEFT
            dx = -self.speed * dt
            moved = True
        elif keys[pygame.K_RIGHT]:
            self.direction = RIGHT
            dx = self.speed * dt
            moved = True

        if moved:
            self._try_move(dx, dy, game_map, tanks)

        bullet = None
        if keys[pygame.K_SPACE]:
            bullet = self.shoot()

        self.update(dt)
        return bullet

    def _try_move(self, dx, dy, game_map, tanks):
        old_x, old_y = self.x, self.y

        self.x += dx
        if self._collides(game_map, tanks):
            self.x = old_x

        self.y += dy
        if self._collides(game_map, tanks):
            self.y = old_y

        self.row, self.col = self._get_grid_pos()

    def _collides(self, game_map, tanks):
        r = self.get_rect()
        if r.left < 0 or r.right > COLS * CELL or r.top < 0 or r.bottom > SCREEN_H:
            return True
        if game_map.blocks_tank(self.get_rect()):
            return True
        for t in tanks:
            if t is not self and t.alive and isinstance(t, EnemyTank):
                if r.colliderect(t.get_rect()):
                    return True
        return False

    def respawn(self):
        self.col, self.row = 6, 12
        self.direction = UP
        self._update_pixel_pos()
        self.alive = True


class EnemyTank(Tank):
    def __init__(self, col, row):
        super().__init__(col, row, DOWN, RED)
        self.speed = ENEMY_SPEED
        self.ai_timer = 0
        self.ai_dir_timer = 0
        self.direction_change_interval = 1.0

    def set_ai(self, dt, game_map, player_tank, tanks, bullets):
        self.ai_timer += dt
        self.ai_dir_timer += dt

        if self.ai_dir_timer >= self.direction_change_interval:
            self.ai_dir_timer = 0
            self._choose_direction(game_map, player_tank)

        dx, dy = DIR_VECTORS[self.direction]
        self._try_move(dx * self.speed * dt, dy * self.speed * dt, game_map, tanks)

        shot = None
        if self.ai_timer >= ENEMY_SHOOT_COOLDOWN:
            self.ai_timer = 0
            if self._should_shoot(game_map, player_tank, bullets):
                shot = self.shoot()

        self.update(dt)
        return shot

    def _choose_direction(self, game_map, player_tank):
        # 70% 概率朝向玩家，30% 随机
        if random.random() < 0.7 and player_tank.alive:
            dr = player_tank.row - self.row
            dc = player_tank.col - self.col
            if abs(dr) > abs(dc):
                self.direction = DOWN if dr > 0 else UP
            else:
                self.direction = RIGHT if dc > 0 else LEFT
        else:
            self.direction = random.choice([UP, DOWN, LEFT, RIGHT])

    def _should_shoot(self, game_map, player_tank, bullets):
        # 与玩家在同行或同列时射击
        if not player_tank.alive:
            return False
        if self.row == player_tank.row:
            return abs(self.col - player_tank.col) <= 6
        if self.col == player_tank.col:
            return abs(self.row - player_tank.row) <= 6
        return False

    def _try_move(self, dx, dy, game_map, tanks):
        old_x, old_y = self.x, self.y

        self.x += dx
        if self._collides(game_map, tanks):
            self.x = old_x
            self.direction = random.choice([UP, DOWN, LEFT, RIGHT])

        self.y += dy
        if self._collides(game_map, tanks):
            self.y = old_y
            self.direction = random.choice([UP, DOWN, LEFT, RIGHT])

        self.row, self.col = self._get_grid_pos()

    def _collides(self, game_map, tanks):
        r = self.get_rect()
        if r.left < 0 or r.right > COLS * CELL or r.top < 0 or r.bottom > SCREEN_H:
            return True
        if game_map.blocks_tank(self.get_rect()):
            return True
        for t in tanks:
            if t is not self and t.alive:
                if r.colliderect(t.get_rect()):
                    return True
        return False
