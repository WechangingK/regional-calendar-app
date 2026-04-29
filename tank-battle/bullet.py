import pygame
from settings import *


class Bullet:
    def __init__(self, x, y, direction, owner):
        self.x = x
        self.y = y
        self.direction = direction
        self.owner = owner    # 'player' or 'enemy'
        self.alive = True
        self.speed = BULLET_SPEED
        dx, dy = DIR_VECTORS[direction]
        self.vx = dx * self.speed
        self.vy = dy * self.speed

    def update(self, dt):
        self.x += self.vx * dt
        self.y += self.vy * dt
        if not (0 <= self.x <= SCREEN_W and 0 <= self.y <= SCREEN_H):
            self.alive = False

    def draw(self, screen):
        r = pygame.Rect(int(self.x) - 3, int(self.y) - 3, 6, 6)
        pygame.draw.rect(screen, WHITE, r)

    def cell(self):
        return int(self.y // CELL), int(self.x // CELL)

    def get_rect(self):
        return pygame.Rect(int(self.x) - 3, int(self.y) - 3, 6, 6)
