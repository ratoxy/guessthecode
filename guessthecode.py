import streamlit as st
import copy

def main():
    st.set_page_config(page_title="Qual é o Código?", layout="wide")
    
    # Initialize session state
    if 'players' not in st.session_state:
        positions = ["A", "B", "C", "D", "E"]
        initial_annotations = {
            "somaABC": "",
            "somaBCD": "",
            "somaCDE": "",
            "somaABCDE": "",
            "qtdPretos": "",
            "qtdBrancos": "",
            "qtdPares": "",
            "qtdImpares": "",
            "numberMarks": [False] * 10
        }
        
        st.session_state.players = [
            {
                "id": "jogador1",
                "name": "Jogador 1",
                "code": [{"number": "", "color": ""} for _ in positions],
                "annotations": copy.deepcopy(initial_annotations)
            },
            {
                "id": "jogador2",
                "name": "Jogador 2",
                "code": [{"number": "", "color": ""} for _ in positions],
                "annotations": copy.deepcopy(initial_annotations)
            }
        ]
    
    if 'active_tab' not in st.session_state:
        st.session_state.active_tab = st.session_state.players[0]['id']
    
    st.title("Qual é o Código?")
    
    # Create tabs for players
    tab_labels = [p['name'] for p in st.session_state.players]
    tabs = st.tabs(tab_labels + ["+"])
    
    # Player tabs content
    for i, player in enumerate(st.session_state.players):
        with tabs[i]:
            display_player_tab(player, i)
    
    # Add player button
    with tabs[-1]:
        if st.button("Adicionar Jogador"):
            add_player()
            st.rerun()
    
    # Reset all button
    if st.button("Reiniciar Jogo", use_container_width=True):
        reset_all()
        st.rerun()

def display_player_tab(player, player_index):
    st.subheader(f"{player['name']} - Código Secreto")
    
    # Code input
    cols = st.columns(5)
    for i in range(5):
        with cols[i]:
            position_label = chr(65 + i)  # A, B, C, D, E
            player['code'][i]['number'] = st.text_input(
                f"Posição {position_label}",
                value=player['code'][i]['number'],
                key=f"num_{player['id']}_{i}",
                placeholder="Número"
            )
            
            color = st.selectbox(
                f"Cor {position_label}",
                options=["", "branco", "preto", "verde"],
                index=["", "branco", "preto", "verde"].index(player['code'][i]['color']),
                key=f"col_{player['id']}_{i}",
                format_func=lambda x: "Selecione..." if x == "" else x.capitalize()
            )
            player['code'][i]['color'] = color
            
            # Display color preview
            if color:
                color_map = {
                    "branco": "white",
                    "preto": "black",
                    "verde": "green"
                }
                st.markdown(
                    f"<div style='width:30px; height:30px; background-color:{color_map[color]}; "
                    f"border:1px solid gray; border-radius:50%; margin:0 auto;'></div>",
                    unsafe_allow_html=True
                )
    
    # Annotations
    st.subheader("Anotações & Deduções")
    col1, col2 = st.columns(2)
    
    with col1:
        player['annotations']['somaABC'] = st.text_input("Soma ABC", value=player['annotations']['somaABC'], key=f"somaABC_{player['id']}")
        player['annotations']['somaBCD'] = st.text_input("Soma BCD", value=player['annotations']['somaBCD'], key=f"somaBCD_{player['id']}")
        player['annotations']['somaCDE'] = st.text_input("Soma CDE", value=player['annotations']['somaCDE'], key=f"somaCDE_{player['id']}")
        player['annotations']['somaABCDE'] = st.text_input("Soma ABCDE", value=player['annotations']['somaABCDE'], key=f"somaABCDE_{player['id']}")
    
    with col2:
        player['annotations']['qtdPretos'] = st.text_input("Qtd. Pretos", value=player['annotations']['qtdPretos'], key=f"qtdPretos_{player['id']}")
        player['annotations']['qtdBrancos'] = st.text_input("Qtd. Brancos", value=player['annotations']['qtdBrancos'], key=f"qtdBrancos_{player['id']}")
        player['annotations']['qtdPares'] = st.text_input("Qtd. Pares", value=player['annotations']['qtdPares'], key=f"qtdPares_{player['id']}")
        player['annotations']['qtdImpares'] = st.text_input("Qtd. Ímpares", value=player['annotations']['qtdImpares'], key=f"qtdImpares_{player['id']}")
    
    # Number marks
    st.write("Números Possíveis:")
    number_cols = st.columns(10)
    for i in range(10):
        with number_cols[i]:
            if st.button(
                "X" if player['annotations']['numberMarks'][i] else str(i),
                key=f"num_mark_{player['id']}_{i}",
                use_container_width=True,
                type="primary" if player['annotations']['numberMarks'][i] else "secondary"
            ):
                player['annotations']['numberMarks'][i] = not player['annotations']['numberMarks'][i]
                st.rerun()

def add_player():
    positions = ["A", "B", "C", "D", "E"]
    initial_annotations = {
        "somaABC": "",
        "somaBCD": "",
        "somaCDE": "",
        "somaABCDE": "",
        "qtdPretos": "",
        "qtdBrancos": "",
        "qtdPares": "",
        "qtdImpares": "",
        "numberMarks": [False] * 10
    }
    
    new_player = {
        "id": f"jogador{len(st.session_state.players) + 1}",
        "name": f"Jogador {len(st.session_state.players) + 1}",
        "code": [{"number": "", "color": ""} for _ in positions],
        "annotations": copy.deepcopy(initial_annotations)
    }
    
    st.session_state.players.append(new_player)
    st.session_state.active_tab = new_player['id']

def reset_all():
    positions = ["A", "B", "C", "D", "E"]
    initial_annotations = {
        "somaABC": "",
        "somaBCD": "",
        "somaCDE": "",
        "somaABCDE": "",
        "qtdPretos": "",
        "qtdBrancos": "",
        "qtdPares": "",
        "qtdImpares": "",
        "numberMarks": [False] * 10
    }
    
    st.session_state.players = [
        {
            "id": "jogador1",
            "name": "Jogador 1",
            "code": [{"number": "", "color": ""} for _ in positions],
            "annotations": copy.deepcopy(initial_annotations)
        },
        {
            "id": "jogador2",
            "name": "Jogador 2",
            "code": [{"number": "", "color": ""} for _ in positions],
            "annotations": copy.deepcopy(initial_annotations)
        }
    ]
    st.session_state.active_tab = st.session_state.players[0]['id']

if __name__ == "__main__":
    main()
