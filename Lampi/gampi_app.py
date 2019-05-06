import kivy
from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.boxlayout import BoxLayout
from kivy.properties import ListProperty, NumericProperty, StringProperty
from kivy.graphics import Color
from kivy.uix.button import Button
import random
from kivy.clock import Clock
from kivy.uix.widget import Widget

class GampiButton(Button):
    def callback(self, instance):
        GampiGrid().changeAllViews()
        self.text = "GAMPI STARTED!"
    def __init__(self,**kwargs):
        super(GampiButton,self).__init__(**kwargs)
        self.text = "Start Gampi!"
        self.font_size = 30
        self.size_hint_y = 0.3
        self.background_color = [1, 0, 1, 1]
        self.bind(on_press=self.callback)

class GampiGrid(GridLayout):
    def changeAllViews(self):
        print("SHUFFLING")
        dict = {"#FF0000": 4,
                "#0000FF": 4,
                "#00FFFF": 4,
                "#FFFF00": 4,
                "#00FF00": 4,
                "#FFA500": 4,
                "#000000": 1}
        rgbaDict = {"#FF0000": [1, 0, 0, 1],
                 "#0000FF": [0, 0, 1, 1],
                 "#00FFFF": [0, 1, 1, 1],
                 "#FFFF00": [1, 1, 0, 1],
                 "#00FF00": [0, 1, 0, 1],
                 "#FFA500": [1, 0.647, 0, 1],
                 "#000000": [0, 0, 0, 1]
                    }
        color_dict = {"#FF0000": "R",
                    "#0000FF": "B",
                    "#00FFFF": "C",
                    "#FFFF00": "Y",
                    "#00FF00": "G",
                    "#FFA500": "O",
                    "#000000": "E"}

        color_list = ["#FF0000", "#0000FF", "#00FFFF", "#FFFF00", "#FFA500", "#000000", "#00FF00"]
        grid_colors_list = []
        grid_colors = ListProperty([])
        grid_colors_txt = []
        for i in range(25):
            validColor = False
            while not validColor:
                index = random.randrange(0, 7, 1)
                if dict.get(color_list[index]) > 0:
                    if color_list[index] == "#000000" and i not in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                        dict[color_list[index]] -=1
                        grid_colors_list.append(color_list[index])
                        grid_colors_txt.append(color_dict[color_list[index]] + "\n")
                        validColor = True
                    elif color_list[index] == "#000000" and i in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                        continue
                    else:
                        grid_colors_list.append(color_list[index])
                        grid_colors_txt.append(color_dict[color_list[index]] + "\n")
                        dict[color_list[index]] -=1
                        validColor = True
        grid_colors = grid_colors_list
        grid_colors_file = open("board_colors.txt", "r+")
        grid_colors_file.truncate(0)
        grid_colors_file = open("board_colors.txt", "a")
        grid_colors_file.writelines(grid_colors_txt)
        grid_colors_file.close()
        for i in range(25):
            GampiApp().grid_colors_list[i] = grid_colors_list[i]

    def change_color(self, instance):
        rgbaDict = {"#FF0000": [1, 0, 0, 1],
                 "#0000FF": [0, 0, 1, 1],
                 "#00FFFF": [0, 1, 1, 1],
                 "#FFFF00": [1, 1, 0, 1],
                 "#00FF00": [0, 1, 0, 1],
                 "#FFA500": [1, 0.647, 0, 1],
                 "#000000": [0, 0, 0, 1]
                }
        nums = [6,7,8,11,12,13,16,17,18]
        for i in range(len(self.children)):
            self.children[i].background_color = rgbaDict[GampiApp().grid_colors_list[nums[-i]]]

    def __init__(self,**kwargs):
        super(GampiGrid,self).__init__(**kwargs)
        self.cols = 3
        self.rows = 3
        self.size_hint_y = 0.7
        for i in range(len(GampiApp().grid_colors)):
            if i in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                self.add_widget(Button(label = "button" + str(i), text = str(i), background_color = GampiApp().rgbaDict[GampiApp().grid_colors[i]]))
        self.event = Clock.schedule_interval(self.change_color,0.2)

class GampiMain(BoxLayout):
    def __init__(self,**kwargs):
        super(GampiMain,self).__init__(**kwargs)
        self.orientation = "vertical"
        self.add_widget(GampiButton(background_color = [1, 1, 1, 1]))
        self.add_widget(GampiGrid())

class GampiApp(App):
    def build(self):
        return GampiMain()

    def update_grid_colors(self, new_colors):
        print("UPDATING")
        self.grid_colors_list = new_colors

    print("CREATING BOARD")
    dict = {"#FF0000": 4,
            "#0000FF": 4,
            "#00FFFF": 4,
            "#FFFF00": 4,
            "#00FF00": 4,
            "#FFA500": 4,
            "#000000": 1}

    rgbaDict = {"#FF0000": [1, 0, 0, 1],
                "#0000FF": [0, 0, 1, 1],
                "#00FFFF": [0, 1, 1, 1],
                "#FFFF00": [1, 1, 0, 1],
                "#00FF00": [0, 1, 0, 1],
                "#FFA500": [1, 0.647, 0, 1],
                "#000000": [0, 0, 0, 1]
               }

    color_dict = {"#FF0000": "R",
                  "#0000FF": "B",
                  "#00FFFF": "C",
                  "#FFFF00": "Y",
                  "#00FF00": "G",
                  "#FFA500": "O",
                  "#000000": "E"
                 }

    color_list = ["#FF0000", "#0000FF", "#00FFFF", "#FFFF00", "#FFA500", "#000000", "#00FF00"]
    grid_colors = ListProperty([])
    grid_colors_list = []
    grid_colors_txt = []

    for i in range(25):
        validColor = False
        while not validColor:
            index = random.randrange(0, 7, 1)
            if dict.get(color_list[index]) > 0:
                if color_list[index] == "#000000" and i not in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                    dict[color_list[index]] -=1
                    grid_colors_list.append(color_list[index])
                    grid_colors_txt.append(color_dict[color_list[index]] + "\n")
                    validColor = True
                elif color_list[index] == "#000000" and i in [6, 7, 8, 11, 12, 13, 16, 17, 18]:
                    continue
                else:
                    grid_colors_list.append(color_list[index])
                    grid_colors_txt.append(color_dict[color_list[index]] + "\n")
                    dict[color_list[index]] -=1
                    validColor = True

    grid_colors = grid_colors_list
    for color in grid_colors_list:
        print(color_dict[color])
    grid_colors_file = open("board_colors.txt", "r+")
    grid_colors_file.truncate(0)
    grid_colors_file = open("board_colors.txt", "a")
    grid_colors_file.writelines(grid_colors_txt)
    grid_colors_file.close()

if __name__ == '__main__':
    GampiApp().run()
