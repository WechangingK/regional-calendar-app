import pygame
import sys
from settings import *
from map import GameMap, LEVELS
from tank import PlayerTank, EnemyTank
from ui import draw_hud, draw_start_screen, draw_level_complete, draw_game_over_screen


class Game:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((SCREEN_W, SCREEN_H))
        pygame.display.set_caption("坦克大战 - Tank Battle")
        self.clock = pygame.time.Clock()
        self.state = START
        self.level = 0
        self.reset()

    def reset(self):
        self.game_map = GameMap(self.level)
        self.player = PlayerTank(6, 12)
        self.enemies = []
        self.bullets = []
        self.enemies_killed = 0
        self.game_map.spawn_timer = 0

    def run(self):
        while True:
            dt = self.clock.tick(FPS) / 1000.0

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        pygame.quit()
                        sys.exit()
                    if event.key == pygame.K_RETURN:
                        if self.state == START:
                            self.state = PLAYING
                            self.level = 0
                            self.reset()
                        elif self.state == LEVEL_COMPLETE:
                            self.level = (self.level + 1) % len(LEVELS)
                            self.reset()
                            self.state = PLAYING
                        elif self.state == GAME_OVER:
                            self.state = START

            if self.state == START:
                self.screen.fill(BLACK)
                draw_start_screen(self.screen)

            elif self.state == PLAYING:
                self._update(dt)
                self._render()

            elif self.state == LEVEL_COMPLETE:
                self._render()
                draw_level_complete(self.screen, self.level)

            elif self.state == GAME_OVER:
                self._render()
                reason = "基地被摧毁!" if not self.game_map.base_alive else "生命耗尽!"
                draw_game_over_screen(self.screen, reason)

            pygame.display.flip()

    def _update(self, dt):
        keys = pygame.key.get_pressed()

        # 玩家输入
        if self.player.alive:
            bullet = self.player.handle_input(dt, keys, self.game_map, self.enemies)
            if bullet:
                self.bullets.append(bullet)
        elif self.player.lives > 0:
            self.player.respawn_timer -= dt
            if self.player.respawn_timer <= 0:
                self.player.respawn()
                self.player.lives -= 1

        # 敌人生成
        self.game_map.spawn_timer += dt
        if (self.game_map.spawn_timer >= SPAWN_INTERVAL and
                self.game_map.enemies_spawned < ENEMIES_PER_LEVEL and
                len([e for e in self.enemies if e.alive]) < MAX_ACTIVE_ENEMIES):
            self.game_map.spawn_timer = 0
            col, row = self.game_map.get_spawn_pos()
            if self.game_map.get(row, col) == EMPTY:
                self.enemies.append(EnemyTank(col, row))
                self.game_map.enemies_spawned += 1

        # 敌人 AI
        for enemy in self.enemies:
            if enemy.alive:
                bullet = enemy.set_ai(dt, self.game_map, self.player,
                                      self.enemies, self.bullets)
                if bullet:
                    self.bullets.append(bullet)

        # 子弹更新与碰撞
        for bullet in self.bullets[:]:
            if not bullet.alive:
                self.bullets.remove(bullet)
                continue

            bullet.update(dt)

            # 子弹碰撞地图
            br, bc = bullet.cell()
            if self.game_map.get(br, bc) in (BRICK, STEEL, BASE):
                self.game_map.damage(br, bc)
                bullet.alive = False
                if not self.game_map.base_alive:
                    self._on_game_over()

            # 子弹碰撞坦克
            br = bullet.get_rect()

            if bullet.owner == 'player':
                for enemy in self.enemies:
                    if enemy.alive and br.colliderect(enemy.get_rect()):
                        enemy.alive = False
                        bullet.alive = False
                        self.enemies_killed += 1
                        break
            elif bullet.owner == 'enemy':
                if self.player.alive and br.colliderect(self.player.get_rect()):
                    self.player.alive = False
                    self.player.respawn_timer = 1.0
                    self.player.lives -= 1
                    bullet.alive = False
                    if self.player.lives <= 0:
                        self._on_game_over()

            if not bullet.alive:
                if bullet in self.bullets:
                    self.bullets.remove(bullet)

        # 检查过关
        if (self.enemies_killed >= ENEMIES_PER_LEVEL and
                len([e for e in self.enemies if e.alive]) == 0):
            self.state = LEVEL_COMPLETE

        # 检查基地是否被玩家误击
        if not self.game_map.base_alive:
            self._on_game_over()

    def _on_game_over(self):
        self.state = GAME_OVER

    def _render(self):
        self.screen.fill(BLACK)

        # 游戏区域背景
        bg = pygame.Rect(0, 0, COLS * CELL, SCREEN_H)
        pygame.draw.rect(self.screen, BLACK, bg)

        # 地图
        self.game_map.draw(self.screen)

        # 坦克
        for enemy in self.enemies:
            if enemy.alive:
                enemy.draw(self.screen)
        if self.player.alive:
            self.player.draw(self.screen)

        # 子弹
        for bullet in self.bullets:
            bullet.draw(self.screen)

        # 面板
        draw_hud(self.screen, self.player, self.level,
                 ENEMIES_PER_LEVEL - self.enemies_killed)


if __name__ == "__main__":
    Game().run()
