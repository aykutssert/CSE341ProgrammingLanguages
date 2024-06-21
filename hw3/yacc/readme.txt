YACC:

Dosyadan okuma ve terminalden input alarak çalışır.
Makefile ile derleme yapılır.
run: 
	yacc -d -o gpp_interpreter.c gpp_interpreter.y
	flex -o gpp_lexer.c gpp_lexer.l 
	gcc gpp_lexer.c gpp_interpreter.c  -o main -ll -w
	./main
input:
	./main input.gpp

output:
	./main input.gpp > output.txt
1) make run terminalden input alır.
2) make input dosyadan okuma yapar.
3) make output ise input dosyasından okuyup output dosyasına çıktıları yazar.
Fonksiyon tanımlamada Function struct’ı kullanıldı.
Valueb sayısını tutmak için ise Valueb struct’ı kullanıldı.
4 işlem doğru çalışıyor.
Fonksiyon tanımlamada parametresiz fonksiyon gelen expression’u return ediyor şeklinde yapıldı.
Tek parametreli fonksiyonda ise örneğin (def sum x (+ x 3b2)) şeklinde ise 3b2 sayısı hafıza da tutuldu(temp2 değeri ile). Daha sonra fonksiyon çağırıldığında 3b2 ile girilen değer toplandı.
İki parametreli fonksiyon ise girilen değerleri operator’ün türüne göre işleme soktu.
Input grammer’ine Comment tokeni ve exit tokeni eklendi.

