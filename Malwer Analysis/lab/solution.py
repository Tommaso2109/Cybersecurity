import itertools
import subprocess
import sys

# Le risposte delle prime 5 fasi
PHASES_1_TO_5 = [
    "Public speaking is very easy.",
    "1 2 6 24 120 720",
    "1 b 214",
    "9",
    "opekma"
]

def run_test():
    print("[*] Avvio bruteforce della Fase 6 in corso...\n")
    
    # Genera tutte le 720 permutazioni dei numeri da 1 a 6
    for perm in itertools.permutations(range(1, 7)):
        candidate_seq = " ".join(map(str, perm))
        
        # Prepara l'input completo da inviare al processo
        full_input = "\n".join(PHASES_1_TO_5 + [candidate_seq]) + "\n"
        
        try:
            # Avvia l'eseguibile Bomb.exe
            process = subprocess.Popen(
                ["Bomb.exe"],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            
            output, _ = process.communicate(input=full_input)
            
            # Controlla se la bomba è esplosa o se abbiamo superato la Fase 6
            if "BOOM" not in output and ("Phase 6 defused" in output or "Congratulations" in output or "defused" in output):
                print("=" * 50)
                print(f" SUCCESS! Sequenza trovata per la Fase 6: {candidate_seq}")
                print("=" * 50)
                print("\nOutput di Bomb.exe:\n")
                print(output)
                return candidate_seq
                
        except FileNotFoundError:
            print("[!] Errore: Impossibile trovare Bomb.exe nella cartella corrente!")
            sys.exit(1)

    print("[!] Nessuna combinazione ha funzionato. Verifica l'input delle prime 5 fasi.")
    return None

if __name__ == "__main__":
    run_test()