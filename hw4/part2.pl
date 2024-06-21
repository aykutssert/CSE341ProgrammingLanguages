classify(SepalLength, SepalWidth, PetalLength, PetalWidth, Class) :-
    (PetalLength =< 2.45 ->
        Class = 'Iris-setosa'
    ;
        (PetalWidth =< 1.75 ->
            Class = 'Iris-versicolor',
            (PetalLength =< 4.95 ->
                Class = 'Iris-versicolor',
                (PetalWidth =< 1.65 ->
                    Class = 'Iris-versicolor'
                ;
                    Class = 'Iris-virginica'
                )
            ;
                Class = 'Iris-virginica',
                (PetalWidth =< 1.55 ->
                    Class = 'Iris-virginica'
                ;
                    Class = 'Iris-versicolor',
                    (PetalLength =< 5.45 ->
                        Class = 'Iris-versicolor'
                    ;
                        Class = 'Iris-virginica'
                    )
                )
            )
        ;
            Class = 'Iris-virginica',
            (PetalLength =< 4.85 ->
                Class = 'Iris-virginica',
                (SepalWidth =< 3.1 ->
                    Class = 'Iris-virginica'
                ;
                    Class = 'Iris-versicolor'
                )
            ;
                Class = 'Iris-virginica'
            )
        )
    ).

classify(SepalLength, SepalWidth, PetalLength, PetalWidth) :-
    classify(SepalLength, SepalWidth, PetalLength, PetalWidth, Class),
    write(Class), nl.

% classify(5.9,3.0,5.1,1.8).