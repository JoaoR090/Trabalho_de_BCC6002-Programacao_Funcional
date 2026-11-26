import tkinter as tk
from tkinter import filedialog, messagebox


class CGoLGridEditor:

    def __init__(self, root):
        self.root = root
        self.root.title("Editor de Grid - Conway's Game of Life")

        # Configurações padrão
        self.cols = 20
        self.rows = 20
        self.cell_size = 25
        self.grid_data = []
        self.rects = []

        self._setup_ui()
        self.build_grid()

    def _setup_ui(self):
        # Frame de controles superiores
        control_frame = tk.Frame(self.root, pady=8, padx=10)
        control_frame.pack(side=tk.TOP, fill=tk.X)

        tk.Label(control_frame, text="Largura (Colunas):").pack(side=tk.LEFT)
        self.entry_cols = tk.Entry(control_frame, width=5)
        self.entry_cols.insert(0, str(self.cols))
        self.entry_cols.pack(side=tk.LEFT, padx=(2, 10))

        tk.Label(control_frame, text="Altura (Linhas):").pack(side=tk.LEFT)
        self.entry_rows = tk.Entry(control_frame, width=5)
        self.entry_rows.insert(0, str(self.rows))
        self.entry_rows.pack(side=tk.LEFT, padx=(2, 10))

        btn_resize = tk.Button(
            control_frame, text="Criar / Redimensionar", command=self.resize_grid
        )
        btn_resize.pack(side=tk.LEFT, padx=5)

        btn_clear = tk.Button(
            control_frame, text="Limpar", command=self.clear_grid
        )
        btn_clear.pack(side=tk.LEFT, padx=5)

        btn_save = tk.Button(
            control_frame,
            text="Salvar Arquivo (.txt)",
            command=self.save_to_file,
            bg="#4CAF50",
            fg="white",
        )
        btn_save.pack(side=tk.RIGHT, padx=5)

        # Canvas com barras de rolagem para grids grandes
        canvas_frame = tk.Frame(self.root)
        canvas_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=(0, 10))

        self.canvas = tk.Canvas(canvas_frame, bg="white")
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        # Eventos de clique e arraste do mouse
        self.canvas.bind("<Button-1>", self.on_left_click)
        self.canvas.bind("<B1-Motion>", self.on_left_drag)
        self.canvas.bind("<B3-Motion>", self.on_right_drag)
        self.canvas.bind("<Button-3>", self.on_right_drag)

    def resize_grid(self):
        try:
            new_cols = int(self.entry_cols.get())
            new_rows = int(self.entry_rows.get())
            if new_cols <= 0 or new_rows <= 0:
                raise ValueError
            self.cols = new_cols
            self.rows = new_rows
            self.build_grid()
        except ValueError:
            messagebox.showerror(
                "Erro", "Insira valores inteiros positivos para largura e altura."
            )

    def build_grid(self):
        self.canvas.delete("all")
        # Ajusta o tamanho da célula automaticamente se a grid for muito grande
        max_dim = max(self.cols, self.rows)
        self.cell_size = max(8, min(25, 650 // max_dim))

        width = self.cols * self.cell_size
        height = self.rows * self.cell_size
        self.canvas.config(width=width, height=height)

        self.grid_data = [[0 for _ in range(self.cols)] for _ in range(self.rows)]
        self.rects = [[None for _ in range(self.cols)] for _ in range(self.rows)]

        for r in range(self.rows):
            for c in range(self.cols):
                x1 = c * self.cell_size
                y1 = r * self.cell_size
                x2 = x1 + self.cell_size
                y2 = y1 + self.cell_size
                rect = self.canvas.create_rectangle(
                    x1, y1, x2, y2, fill="white", outline="#CCCCCC"
                )
                self.rects[r][c] = rect

    def _get_cell_coords(self, event):
        c = event.x // self.cell_size
        r = event.y // self.cell_size
        if 0 <= r < self.rows and 0 <= c < self.cols:
            return r, c
        return None, None

    def _set_cell(self, r, c, state):
        if self.grid_data[r][c] != state:
            self.grid_data[r][c] = state
            color = "black" if state == 1 else "white"
            self.canvas.itemconfig(self.rects[r][c], fill=color)

    def on_left_click(self, event):
        r, c = self._get_cell_coords(event)
        if r is not None:
            new_state = 0 if self.grid_data[r][c] == 1 else 1
            self._set_cell(r, c, new_state)

    def on_left_drag(self, event):
        r, c = self._get_cell_coords(event)
        if r is not None:
            self._set_cell(r, c, 1)

    def on_right_drag(self, event):
        r, c = self._get_cell_coords(event)
        if r is not None:
            self._set_cell(r, c, 0)

    def clear_grid(self):
        for r in range(self.rows):
            for c in range(self.cols):
                self._set_cell(r, c, 0)

    def save_to_file(self):
        filepath = filedialog.asksaveasfilename(
            defaultextension=".txt",
            filetypes=[("Arquivos de Texto", "*.txt"), ("Todos os arquivos", "*.*")],
            title="Salvar Grid do CGoL",
        )
        if not filepath:
            return

        with open(filepath, "w", encoding="utf-8") as f:
            f.write(f"{self.cols}\n")
            f.write(f"{self.rows}\n")
            for row in self.grid_data:
                f.write(" ".join(map(str, row)) + "\n")

        messagebox.showinfo("Sucesso", f"Grid salva com sucesso em:\n{filepath}")


if __name__ == "__main__":
    root = tk.Tk()
    app = CGoLGridEditor(root)
    root.mainloop()