@ECHO OFF
ECHO Running HInit Commands (Building Models)...

HInit -S lists/trainList.txt -l alice -L labels/train -M hmms -o alice -T 1 lib/states.txt
HInit -S lists/trainList.txt -l alex -L labels/train -M hmms -o alex -T 1 lib/states.txt
HInit -S lists/trainList.txt -l brett -L labels/train -M hmms -o brett -T 1 lib/states.txt
HInit -S lists/trainList.txt -l ebtesam -L labels/train -M hmms -o ebtesam -T 1 lib/states.txt
HInit -S lists/trainList.txt -l george -L labels/train -M hmms -o george -T 1 lib/states.txt
HInit -S lists/trainList.txt -l hao -L labels/train -M hmms -o hao -T 1 lib/states.txt
HInit -S lists/trainList.txt -l jack -L labels/train -M hmms -o jack -T 1 lib/states.txt
HInit -S lists/trainList.txt -l james -L labels/train -M hmms -o james -T 1 lib/states.txt
HInit -S lists/trainList.txt -l julien -L labels/train -M hmms -o julien -T 1 lib/states.txt
HInit -S lists/trainList.txt -l kevin -L labels/train -M hmms -o kevin -T 1 lib/states.txt
HInit -S lists/trainList.txt -l luzhang -L labels/train -M hmms -o luzhang -T 1 lib/states.txt
HInit -S lists/trainList.txt -l matt -L labels/train -M hmms -o matt -T 1 lib/states.txt
HInit -S lists/trainList.txt -l matthew -L labels/train -M hmms -o matthew -T 1 lib/states.txt
HInit -S lists/trainList.txt -l max -L labels/train -M hmms -o max -T 1 lib/states.txt
HInit -S lists/trainList.txt -l mazvydas -L labels/train -M hmms -o mazvydas -T 1 lib/states.txt
HInit -S lists/trainList.txt -l peter -L labels/train -M hmms -o peter -T 1 lib/states.txt
HInit -S lists/trainList.txt -l rory -L labels/train -M hmms -o rory -T 1 lib/states.txt
HInit -S lists/trainList.txt -l ruari -L labels/train -M hmms -o ruari -T 1 lib/states.txt
HInit -S lists/trainList.txt -l sevkan -L labels/train -M hmms -o sevkan -T 1 lib/states.txt
HInit -S lists/trainList.txt -l thomas -L labels/train -M hmms -o thomas -T 1 lib/states.txt
HInit -S lists/trainList.txt -l sil -L labels/train -M hmms -o sil -T 1 lib/states.txt

ECHO Running HMM re-estimation...
HRest -S lists/trainList.txt -l alice -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l alex -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l brett -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l ebtesam -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l george -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l hao -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l jack -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l james -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l julien -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l kevin -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l luzhang -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l matt -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l matthew -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l max -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l mazvydas -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l peter -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l rory -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l ruari -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l sevkan -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l thomas -L labels/train -M hmms -T 1 lib/states.txt
HRest -S lists/trainList.txt -l sil -L labels/train -M hmms -T 1 lib/states.txt

ECHO Running HMM Viterbi algorithm...
HVite -T 1 -S lists/testList.txt -d hmms/ -w lib/NET -l results lib/dict lib/words3

ECHO Printing results...
HResults -p -e "???" sil -e "???" sp -L labels/test lib/words3 results/speech002.rec results/speech004.rec results/speech006.rec results/speech008.rec results/speech010.rec results/speech012.rec results/speech014.rec results/speech016.rec results/speech018.rec results/speech020.rec > .\results.txt
