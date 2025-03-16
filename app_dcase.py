
# import gradio as gr
# from msclap import CLAP

# clap_model = CLAP(version = 'clapcap', use_cuda=False)

# def clap_inference(mic=None, file=None):

#     if mic is not None:
#         audio = mic
#     elif file is not None:
#         audio = file
#     else:
#         return "You must either provide a mic recording or a file"

#     # Generate captions for the recording
#     captions = clap_model.generate_caption([audio], 
#                                            resample=True, 
#                                            beam_size=5, 
#                                            entry_length=67, 
#                                            temperature=0.01)

#     return captions[0]

import gradio as gr
from dcase24t6.nn.hub import baseline_pipeline
import librosa

model = baseline_pipeline()

def dcase_inference(mic=None, file=None):

    if mic is not None:
        audio = mic
        sr = 48000
        print(f"sr 1: {sr}")
    elif file is not None:
        print(f"file 1: {file}")
        audio, sr = librosa.load(file, sr=None)
        print(f"file 1: {sr}")
    else:
        return "You must either provide a mic recording or a file"

    # Generate captions for the recording
    item = {"audio": audio, "sr": sr}
    outputs = model(item)
    candidate = outputs["candidates"][0]

    return candidate

def create_app():

    with gr.Blocks() as demo:
        gr.Markdown(
            """
            # DCASE demo for automatic audio captioning
            """
        )
        gr.Interface(
            fn=dcase_inference,
            inputs=[
                gr.Audio(sources="microphone", type="filepath"),
                gr.Audio(sources="upload", type="filepath"),
            ],
            outputs="text",
        )

    return demo

def main():
    
    app = create_app()
    app.launch(debug=True)

    
if __name__ == "__main__":
    main()

