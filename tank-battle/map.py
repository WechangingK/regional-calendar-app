import pygame
from settings import *

# 地图定义: 0=空, 1=砖墙, 2=钢铁, 3=水, 4=树, 5=基地
# 13列 x 13行

LEVELS = [
    # 关卡 1 - 经典布局
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,1,1,0,1,1,1,0,1,1,0,0],
        [0,0,1,1,0,1,0,1,0,1,1,0,0],
        [0,0,1,0,0,0,0,0,0,0,1,0,0],
        [0,1,1,0,0,2,0,2,0,0,1,1,0],
        [1,1,0,0,0,0,0,0,0,0,0,1,1],
        [1,0,0,0,1,0,4,0,1,0,0,0,1],
        [1,0,0,1,0,0,4,0,0,1,0,0,1],
        [0,0,0,0,0,0,4,0,0,0,0,0,0],
        [0,0,1,0,0,0,0,0,0,0,1,0,0],
        [0,0,1,0,2,1,0,1,2,0,1,0,0],
        [0,0,1,0,0,0,0,0,0,0,1,0,0],
        [0,0,0,0,0,0,5,0,0,0,0,0,0],
    ],
    # 关卡 2 - 钢铁堡垒
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,2,2,0,1,1,0,1,1,0,2,2,0],
        [0,2,0,0,1,0,0,0,1,0,0,2,0],
        [0,0,0,1,0,0,1,0,0,1,0,0,0],
        [1,1,0,0,0,2,0,2,0,0,0,1,1],
        [1,0,0,0,0,0,0,0,0,0,0,0,1],
        [0,0,0,1,0,3,3,3,0,1,0,0,0],
        [0,0,1,0,0,3,4,3,0,0,1,0,0],
        [0,0,0,1,0,3,3,3,0,1,0,0,0],
        [0,1,1,0,0,0,0,0,0,0,1,1,0],
        [0,0,0,0,2,0,1,0,2,0,0,0,0],
        [0,1,1,0,0,0,0,0,0,0,1,1,0],
        [0,0,0,0,0,0,5,0,0,0,0,0,0],
    ],
    # 关卡 3 - 水路迷宫
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,1,1,1,0,2,0,2,0,1,1,1,0],
        [0,1,0,1,0,0,0,0,0,1,0,1,0],
        [0,1,0,1,3,3,0,3,3,1,0,1,0],
        [0,0,0,0,3,0,0,0,3,0,0,0,0],
        [2,0,0,0,0,0,4,0,0,0,0,0,2],
        [0,0,1,0,0,4,4,4,0,0,1,0,0],
        [2,0,0,0,0,0,4,0,0,0,0,0,2],
        [0,0,0,0,3,0,0,0,3,0,0,0,0],
        [0,1,0,1,3,3,0,3,3,1,0,1,0],
        [0,1,0,1,0,0,0,0,0,1,0,1,0],
        [0,1,1,1,0,2,0,2,0,1,1,1,0],
        [0,0,0,0,0,0,5,0,0,0,0,0,0],
    ],
]


class GameMap:
    def __init__(self, level_index=0):
        self.load_level(level_index)

    def load_level(self, level_index):
        data = LEVELS[level_index % len(LEVELS)]
        self.grid = [row[:] for row in data]
        self.original = [row[:] for row in data]
        self.enemies_spawned = 0
        self.spawn_timer = 0
        self.spawn_points = [(0, 0), (6, 0), (12, 0)]
        self.base_alive = True

    def get(self, row, col):
        if 0 <= row < ROWS and 0 <= col < COLS:
            return self.grid[row][col]
        return STEEL

    def set(self, row, col, tile):
        if 0 <= row < ROWS and 0 <= col < COLS:
            self.grid[row][col] = tile

    def blocks_tank(self, rect):
        """检查矩形区域是否与阻挡坦克的地形碰撞"""
        for row in range(ROWS):
            for col in range(COLS):
                tile = self.grid[row][col]
                if tile in (BRICK, STEEL, WATER):
                    tr = pygame.Rect(col * CELL, row * CELL, CELL, CELL)
                    if rect.colliderect(tr):
                        return True
        return False

    def damage(self, row, col):
        tile = self.get(row, col)
        if tile == BRICK:
            self.set(row, col, EMPTY)
            return True
        elif tile == STEEL:
            return True    # 钢铁挡住子弹但不损坏
        elif tile == BASE:
            self.base_alive = False
            self.set(row, col, EMPTY)
            return True
        return False

    def get_spawn_pos(self):
        import random
        pos = random.choice(self.spawn_points)
        return pos[0], pos[1]

    def draw(self, screen):
        for row in range(ROWS):
            for col in range(COLS):
                tile = self.grid[row][col]
                x, y = col * CELL, row * CELL
                if tile == BRICK:
                    r = pygame.Rect(x, y, CELL, CELL)
                    pygame.draw.rect(screen, BROWN, r)
                    pygame.draw.rect(screen, BLACK, r, 2)
                    # 砖纹
                    for i in range(2):
                        pygame.draw.line(screen, DARK_GRAY,
                                        (x + CELL // 2, y + i * CELL // 2 + CELL // 4),
                                        (x + CELL, y + i * CELL // 2 + CELL // 4))
                elif tile == STEEL:
                    r = pygame.Rect(x, y, CELL, CELL)
                    pygame.draw.rect(screen, GRAY, r)
                    pygame.draw.rect(screen, DARK_GRAY, r, 3)
                elif tile == WATER:
                    r = pygame.Rect(x, y, CELL, CELL)
                    pygame.draw.rect(screen, BLUE, r)
                    # 水面波纹
                    pygame.draw.line(screen, CYAN, (x, y + 10), (x + CELL, y + 10), 2)
                    pygame.draw.line(screen, CYAN, (x, y + 25), (x + CELL, y + 25), 2)
                elif tile == TREE:
                    r = pygame.Rect(x, y, CELL, CELL)
                    pygame.draw.rect(screen, GREEN, r)
                    pygame.draw.rect(screen, (0, 150, 0), r, 2)
                    # 树冠
                    pygame.draw.circle(screen, (0, 180, 0), (x + CELL // 2, y + CELL // 2), CELL // 2 - 2)
                elif tile == BASE:
                    r = pygame.Rect(x, y, CELL, CELL)
                    pygame.draw.rect(screen, ORANGE, r)
                    # 鹰标
                    cx, cy = x + CELL // 2, y + CELL // 2
                    pygame.draw.polygon(screen, BLACK,
                        [(cx - 8, cy - 8), (cx, cy + 2), (cx + 8, cy - 8)])
