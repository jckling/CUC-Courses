import pygame
import numpy as np

# Settings
SCREEN_WIDTH = 600
SCREEN_HEIGHT = 600
FPS = 30
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)

class App():
    # Init Game
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((SCREEN_WIDTH,SCREEN_HEIGHT+40), 0, 32)
        # pygame.display.set_caption("Life Game")
        self.clock = pygame.time.Clock()
        self.start = False
        self.cells = np.zeros(shape=(SCREEN_HEIGHT//10, SCREEN_WIDTH//10))
        self.FONT = pygame.font.Font('MAIAN.ttf', 18)
        self.RunGame()

    # Renew
    def Re(self):
        global FPS
        self.start = False
        self.cells = np.zeros(shape=(SCREEN_HEIGHT//10, SCREEN_WIDTH//10))
        FPS = 30

    # Game Loop
    def RunGame(self):
        global FPS
        while True:
            # FPS
            self.clock.tick(FPS)

            # Start Logic
            if not self.start:
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        pygame.quit()
                        exit()
                    elif event.type == pygame.MOUSEBUTTONDOWN:
                        x, y = event.pos
                        self.cells[x//10, y//10] = 1
                    else:
                        key_pressed = pygame.key.get_pressed()
                        if key_pressed[pygame.K_ESCAPE]:
                            self.start = True
                            FPS = 2
            else:
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        pygame.quit()
                        exit()
                    else:
                        key_pressed = pygame.key.get_pressed()
                        if key_pressed[pygame.K_ESCAPE]:
                            FPS = 2
                        elif key_pressed[pygame.K_SPACE]:
                            if FPS < 60:
                                FPS += 2
                        elif key_pressed[pygame.K_r]:
                            self.Re()
                
                # Life Cycle
                for i in range(0, SCREEN_WIDTH//10):
                    for j in range(0, SCREEN_HEIGHT//10):
                        living = 0
                        if i+1 < SCREEN_WIDTH//10:
                            living += self.cells[i+1, j]
                            if j+1 < SCREEN_HEIGHT//10:
                                living += self.cells[i+1, j+1]
                            if j-1 >= 0:
                                living += self.cells[i+1, j-1]
                        if i-1 >= 0:
                            living += self.cells[i-1, j]
                            if j+1 < SCREEN_HEIGHT//10:
                                living += self.cells[i-1, j+1]
                            if j-1 >= 0:
                                living += self.cells[i-1, j-1]
                        if j-1 >= 0:
                            living += self.cells[i, j-1]
                        if j+1 < SCREEN_HEIGHT//10:
                            living += self.cells[i, j+1]
                            
                        if self.cells[i, j] == 1:
                            if living < 2 or living > 3:
                                self.cells[i, j] = 0
                            elif living == 2 or living == 3:
                                self.cells[i, j] = 1
                        else:
                            if living == 3:
                                self.cells[i, j] = 1                   
            # Update
            self.DrawBack()
    
    # Flush Screen
    def DrawBack(self):
        # Background Color
        self.screen.fill(BLACK)

        # White Lines
        for i in range(0, SCREEN_WIDTH+1, 10):
            pygame.draw.line(self.screen, WHITE, [i, 0],[i, SCREEN_HEIGHT], 1)
        for i in range(0, SCREEN_HEIGHT+1, 10):
            pygame.draw.line(self.screen, WHITE, [0, i],[SCREEN_WIDTH, i], 1)

        # Cells
        for i in range(0, SCREEN_HEIGHT//10):
            for j in range(0, SCREEN_WIDTH//10):
                if self.cells[i, j] == 1:
                    pygame.draw.rect(self.screen, WHITE, [i*10, j*10, 10, 10], 0)

        # Text - Intro
        startSurf = self.FONT.render("Conway's Game of Life", True, WHITE)
        startRect = startSurf.get_rect()
        startRect.left = 55
        startRect.top = SCREEN_HEIGHT+6
        self.screen.blit(startSurf, startRect)

        # Text - FPS
        speedSurf = self.FONT.render('Speed: ' + str(FPS), True, WHITE)
        speedRect = speedSurf.get_rect()
        speedRect.left = 400
        speedRect.top = SCREEN_HEIGHT+6
        self.screen.blit(speedSurf, speedRect)

        # Rectangle
        pygame.draw.rect(self.screen, WHITE, [45, SCREEN_HEIGHT+3, 200, 30], 2)
        pygame.draw.rect(self.screen, WHITE, [345, SCREEN_HEIGHT+3, 200, 30], 2)

        # Flush
        pygame.display.update()

# Test
if __name__ == "__main__":
    App()