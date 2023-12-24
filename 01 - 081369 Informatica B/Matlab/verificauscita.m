function ok=verificauscita(registro,data_cercata, id_cercato)
    indice=registro.data==data_cercata) & (registro.id== id_cercato)
    if !any(indice)
        ok=0;
    else
        minuti=registro(idx).oraUscita-registro(idx).oraIngresso;
        if minuti>450
            ok=1
        else
            ok=0;
        end
    end