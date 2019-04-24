import kivy
from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import ListProperty, NumericProperty, StringProperty
from kivy.graphics import Color
import random

class Grid(GridLayout):
    pass

class GampiApp(App):
    def build(self):
        return Grid()
    dict = {"#FF0000": 4,
            "#0000FF": 4,
            "#00FFFF": 4,
            "#FFFF00": 4,
            "#00FF00": 4,
            "#FFA500": 4,
            "#000000": 1}

    color_list = ["#FF0000", "#0000FF", "#00FFFF", "#FFFF00", "#FFA500", "#000000", "#00FF00"]
    grid_colors = ListProperty([])
    grid_colors_list = []
    for i in range(25):
        validColor = False
        while not validColor:
            index = random.randrange(0, 7, 1)
            if dict.get(color_list[index]) > 0:
                if color_list[index] == "#000000" and i not in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                    dict[color_list[index]] -=1
                    grid_colors_list.append(color_list[index])
                    validColor = True
                elif color_list[index] == "#000000" and i in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                    continue
                else:
                    grid_colors_list.append(color_list[index])
                    dict[color_list[index]] -=1
                    validColor = True
    grid_colors = grid_colors_list

if __name__ == '__main__':
    GampiApp().run()
