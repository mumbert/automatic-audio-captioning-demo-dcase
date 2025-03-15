import gradio as gr
import app_dcase

def main():

    demo = gr.TabbedInterface([app_dcase.create_app()], 
                            ["DCASE demo"])

    demo.launch()

if __name__ == "__main__":
    main()