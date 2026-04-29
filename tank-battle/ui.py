import pygame
from settings import *

# 字体缓存
_fonts = {}


def _get_font(size):
    if size not in _fonts:
        _fonts[size] = pygame.font.Font(None, size)
    return _fonts[size]


def draw_hud(screen, player, level, enemies_remaining):
    """绘制右侧信息面板"""
    px = COLS * CELL + 10
    font = _get_font(28)
    font_sm = _get_font(20)

    def blit(text, y, color=WHITE, f=font):
        s = f.render(text, True, color)
        screen.blit(s, (px, y))

    blit(f"关卡 {level + 1}", 10, YELLOW)
    blit(f"生命 x {player.lives}", 50, GREEN)
    blit(f"剩余敌人: {enemies_remaining}", 90, RED)

    # 分隔线
    pygame.draw.line(screen, GRAY, (px, 140), (SCREEN_W - 10, 140), 2)

    blit("控制说明", 160, CYAN, font_sm)
    blit("↑↓←→ 移动", 190, WHITE, font_sm)
    blit("空格  射击", 220, WHITE, font_sm)
    blit("ESC   退出", 250, WHITE, font_sm)

    pygame.draw.line(screen, GRAY, (px, 290), (SCREEN_W - 10, 290), 2)

    # 图例
    blit("图例", 310, CYAN, font_sm)
    for i, (color, label) in enumerate([
        (BROWN, "砖墙 (可破坏)"),
        (GRAY, "钢铁 (不可破坏)"),
        (BLUE, "水 (不可通行)"),
        (GREEN, "树 (视野遮盖)"),
        (ORANGE, "基地 (保护!)"),
    ]):
        py = 340 + i * 25
        r = pygame.Rect(px, py, 16, 16)
        pygame.draw.rect(screen, color, r)
        t = font_sm.render(label, True, WHITE)
        screen.blit(t, (px + 22, py - 2))


def draw_start_screen(screen):
    screen.fill(BLACK)
    font_big = _get_font(64)
    font_mid = _get_font(32)
    font_sm = _get_font(22)

    texts = [
        (font_big, "坦克大战", YELLOW, -60),
        (font_mid, "TANK BATTLE", ORANGE, -10),
        (font_sm, "按 ENTER 开始游戏", WHITE, 50),
        (font_sm, "方向键移动 | 空格射击", GRAY, 85),
        (font_sm, "保护基地，消灭所有敌人!", GREEN, 120),
    ]

    for font, text, color, y_off in texts:
        s = font.render(text, True, color)
        x = SCREEN_W // 2 - s.get_width() // 2
        y = SCREEN_H // 2 + y_off
        screen.blit(s, (x, y))

    # 绘制装饰坦克
    for i, (color, dx) in enumerate([(YELLOW, -80), (RED, 80)]):
        cx = SCREEN_W // 2 + dx
        cy = SCREEN_H // 2 - 120
        r = pygame.Rect(cx - 16, cy - 16, 32, 32)
        pygame.draw.rect(screen, color, r, border_radius=5)
        pygame.draw.line(screen, color, (cx, cy), (cx, cy - 22), 7)


def draw_level_complete(screen, level):
    overlay = pygame.Surface((SCREEN_W, SCREEN_H))
    overlay.set_alpha(180)
    overlay.fill(BLACK)
    screen.blit(overlay, (0, 0))

    font = _get_font(48)
    s = font.render(f"关卡 {level + 1} 通过!", True, YELLOW)
    x = SCREEN_W // 2 - s.get_width() // 2
    y = SCREEN_H // 2 - 30
    screen.blit(s, (x, y))

    font_sm = _get_font(24)
    t = font_sm.render("按 ENTER 进入下一关", True, WHITE)
    screen.blit(t, (SCREEN_W // 2 - t.get_width() // 2, y + 55))


def draw_game_over_screen(screen, reason):
    overlay = pygame.Surface((SCREEN_W, SCREEN_H))
    overlay.set_alpha(200)
    overlay.fill(BLACK)
    screen.blit(overlay, (0, 0))

    font = _get_font(56)
    s = font.render("游戏结束", True, RED)
    x = SCREEN_W // 2 - s.get_width() // 2
    screen.blit(s, (x, SCREEN_H // 2 - 60))

    font_mid = _get_font(28)
    r = font_mid.render(reason, True, ORANGE)
    screen.blit(r, (SCREEN_W // 2 - r.get_width() // 2, SCREEN_H // 2 + 10))

    font_sm = _get_font(20)
    t = font_sm.render("按 ENTER 重新开始", True, WHITE)
    screen.blit(t, (SCREEN_W // 2 - t.get_width() // 2, SCREEN_H // 2 + 60))
