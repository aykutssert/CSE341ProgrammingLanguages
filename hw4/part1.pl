% place and distance

place(admin_office).
place(cafe).
place(library).
place(engineering_building).
place(institute_y).
place(social_sciences_building).
place(lecture_hall_a).

% Distance facts
distance(admin_office, cafe, 4).
distance(admin_office, library, 1).
distance(admin_office, engineering_building, 3).

distance(cafe, admin_office, 4).
distance(cafe, library, 5).
distance(cafe, social_sciences_building, 2).

distance(engineering_building, library, 5).
distance(engineering_building, admin_office, 3).
distance(engineering_building, lecture_hall_a, 2).

distance(lecture_hall_a, institute_y, 3).
distance(lecture_hall_a, engineering_building, 2).

distance(library, cafe, 5).
distance(library, admin_office, 1).
distance(library, engineering_building, 5).
distance(library, institute_y, 3).
distance(library, social_sciences_building, 2).

distance(institute_y, lecture_hall_a, 3).
distance(institute_y, library, 3).

distance(social_sciences_building,cafe, 2).
distance(social_sciences_building,library, 2).
distance(social_sciences_building,institute_x, 8).

distance(institute_x,social_sciences_building, 8).


% Delivery personnel facts
delivery_person(1, 20, 8, no_job, admin_office).
delivery_person(2, 15, 12, yes_job, cafe).
delivery_person(3, 25, 16, no_job, library).


% Objects to be delivered facts
object(obj1,5,library,social_sciences_building,low,in_transit(2)).
object(obj2,10,admin_office,library,high,no_delivery).
object(obj3,8,admin_office,institute_x,low, no_delivery).
object(obj4,4,engineering_building,admin_office, medium,no_delivery).
object(obj5,6,cafe,library,high,no_delivery).




% shortest_path/4: Finds the shortest path and distance between Start and End using Dijkstra algorithm
shortest_path(Start, End, Path, Distance) :-
    dijkstra([(0, Start, [])], End, ReversePath, Distance),
    reverse(ReversePath, Path).

% reached the destination
dijkstra([(Distance, End, Path) | _], End, [End | Path], Distance).

% Recursive case: explore neighbors
dijkstra([(CurrentDistance, CurrentNode, CurrentPath) | Rest], End, ShortestPath, ShortestDistance) :-
    % Find all neighbors of the current node and calculate their distances
    findall((NewDistance, Neighbor, [CurrentNode | CurrentPath]),
            (distance(CurrentNode, Neighbor, EdgeWeight),   % EdgeWeight is the weight of the edge
             \+ member(Neighbor, CurrentPath),              % Avoid cycles in the path
             NewDistance is CurrentDistance + EdgeWeight),  % Calculate the new distance
            Neighbors),
    
    % Combine the list of current nodes with their neighbors
    append(Rest, Neighbors, CombinedList),
    
    % Sort the combined list based on distances in ascending order
    sort(CombinedList, SortedList),
    
    % Recursive call with the updated sorted list
    dijkstra(SortedList, End, ShortestPath, ShortestDistance).


% Example usage:
% shortest_path(admin_office, lecture_hall_a, Path, Distance).
% print(admin_office, lecture_hall_a).

print(Start, End) :-
    shortest_path(Start, End, Path, Distance),
    print_result(Path, Distance), !.  % The cut (!) prevents backtracking

print_result(Path, Distance) :-
    write('Shortest Path: '), write(Path), nl,
    write('Shortest Distance: '), write(Distance), write(' units'), nl.


% is_delivery_available/1: Determines if delivery is available for the given OBJECTID
is_delivery_available(OBJECTID) :-
    % Retrieve information about the object with the given OBJECTID
    object(OBJECTID, Weight, PickUp, DropOf, Priority, Status),
    
    % Check the status of the object
    (Status = in_transit(DeliveryPersonID)   ->
        % If the object is already in transit, print a message indicating the delivery person
        write('Object already delivered by Delivery Person '), write(DeliveryPersonID), nl

    ;
        % If the object is not in transit, find available delivery persons and calculate delivery times
        
        % Find all available delivery persons and calculate delivery times
        findall((TotalTime, DeliveryPersonID),
                (member(DeliveryPersonID, [1, 2, 3]),  % Iterate over [1, 2, 3] for available delivery persons
                 delivery_person(DeliveryPersonID, _, _, Status2, CurrentLocation),
                 
                 % Check if the delivery person has no ongoing job and has capacity for the object
                 check_job(DeliveryPersonID, Status2),
                 (Status2 == no_job, check_capacity(DeliveryPersonID, Weight) ->
                     
                     % Calculate the time to pick up and deliver the object
                     shortest_path(CurrentLocation, PickUp, _, TimeToPickup),
                     shortest_path(PickUp, DropOf, _, TimeToDeliver),
                     
                     % Calculate the total time for the delivery
                     TotalTime is TimeToPickup + TimeToDeliver
                 ;
                 
                    
                    ( Status2 == yes_job , check_capacity(DeliveryPersonID, Weight) ->
                        object(_, _, _, _, Priority2, in_transit(DeliveryPersonID)),
                        
                        ( (Priority2 = low , Priority = high) ->
                           
                            % Calculate the time to pick up and deliver the object
                            shortest_path(CurrentLocation, PickUp, _, TimeToPickup),
                            shortest_path(PickUp, DropOf, _, TimeToDeliver),
                     
                            % Calculate the total time for the delivery
                            TotalTime is TimeToPickup + TimeToDeliver
                           
                            ;

                            ( (Priority2 = low , Priority = medium) ->
                            
                            % Calculate the time to pick up and deliver the object
                            shortest_path(CurrentLocation, PickUp, _, TimeToPickup),
                            shortest_path(PickUp, DropOf, _, TimeToDeliver),
                    
                            % Calculate the total time for the delivery
                            TotalTime is TimeToPickup + TimeToDeliver
                            
                            ;
                                    ( (Priority2 = medium , Priority = high) ->
                                        
                                        % Calculate the time to pick up and deliver the object
                                        shortest_path(CurrentLocation, PickUp, _, TimeToPickup),
                                        shortest_path(PickUp, DropOf, _, TimeToDeliver),
                                
                                        % Calculate the total time for the delivery
                                        TotalTime is TimeToPickup + TimeToDeliver
                                        
                                        ;
                                        % If the delivery person is not available, assign a large value to TotalTime
                                        TotalTime = 9999  % A large value, as this delivery person should not be selected in this case
                                    )
                            )
                        )
                        
                    ;

                    % If the delivery person is not available, assign a large value to TotalTime
                    TotalTime = 9999  % A large value, as this delivery person should not be selected in this case
                    )

                     
                 )
                ),
                ResultList
        ),
      
        % Find the minimum total time among the available delivery persons
        find_min_each_person(ResultList)
    ).




% find_min_each_person/1: Finds the minimum total time for each delivery person from the ResultList
find_min_each_person(ResultList) :-
    find_min_each_person(ResultList, MinList),   % Find minimum total time for each delivery person
    work_hour_kontrol(MinList, NewList),         % Perform work hour control on the obtained list
    print_min_each_person(NewList).              % Print the minimum time for each delivery person



work_hour_kontrol([], []). % This is used to terminate the recursive operation.

work_hour_kontrol([(MinTime, CurrentID) | Rest], [Result | RestResult]) :-
    % Retrieve working hours of the current delivery person
    delivery_person(CurrentID, _, WorkingHours, _, _),
    
    % Check if the minimum time is within the working hours
    (       
        MinTime =< WorkingHours ->
            Result = (MinTime, CurrentID)
        ;
            Result = (9999, CurrentID)  % A large value, indicating the delivery person is not selected
    ),
    
    % Recursively process the rest of the list
    work_hour_kontrol(Rest, RestResult),
    
    !. % Cut operator (!) to terminate the process at this point

% work_hour_kontrol/2: Handle cases where there is no match, move on to the next element
work_hour_kontrol([_ | Rest], Result) :-
    work_hour_kontrol(Rest, Result).










% find_min_each_person/2: Finds the minimum total time for each delivery person from the list
find_min_each_person([(TotalTime, DeliveryPersonID) | Rest], MinList) :-
    % Recursive call to find the minimum total time for the rest of the list
    find_min_each_person(Rest, RestMinList),
    
    % Check if there is an entry for the same DeliveryPersonID in the rest of the list
    ( member((MinTime, DeliveryPersonID), RestMinList) ->
        % Compare the total times and update MinList accordingly
        ( TotalTime < MinTime ->
            MinList = [(TotalTime, DeliveryPersonID) | RestMinList]
        ;
            MinList = RestMinList
        )
    ;
        % If there is no entry for the same DeliveryPersonID in the rest of the list, add the current entry
        MinList = [(TotalTime, DeliveryPersonID) | RestMinList]
    ).


% This is used to terminate the recursive operation.
find_min_each_person([], []).

% print_min_each_person/1: Sorts the MinList and prints the minimum time for each delivery person
print_min_each_person(MinList) :-
    sort(MinList, SortedMinList),
    print_min_each_person_for_each_id(SortedMinList, 1).

% print_min_each_person_for_each_id/2: Prints the minimum time for each delivery person, starting from CurrentID
print_min_each_person_for_each_id(MinList, CurrentID) :-
    % Check if there is a minimum time entry for the current Delivery Person ID
    ( member((MinTime, CurrentID), MinList),
      MinTime \= 9999 ->
        % Print the information for the current Delivery Person
        write('Delivery Person '), write(CurrentID),
        write(' has the shortest time of '), write(MinTime), write(' units of time.'), nl,
        
        % If the current ID is less than 3, proceed to the next ID
        (CurrentID < 3 ->
            NextID is CurrentID + 1,
            print_min_each_person_for_each_id(MinList, NextID)
        ; true
        )
    ;
        % If there is no minimum time entry for the current Delivery Person ID, proceed to the next ID
        (CurrentID < 3 ->
            NextID is CurrentID + 1,
            print_min_each_person_for_each_id(MinList, NextID)
        ; true
        )
    ),
    !. % Cut operator (!) to terminate the process at this point




% This is used to terminate the recursive operation.
print_min_each_person_for_each_id(_, _).



% Helper predicate to check working hours
check_working_hours(DeliveryPersonID, ObjectHour) :-
    delivery_person(DeliveryPersonID, _, WorkingHours, _, _),
    ObjectHour =< WorkingHours.

% Helper predicate to check capacity
check_capacity(DeliveryPersonID, Weight) :-
    delivery_person(DeliveryPersonID, Capacity, _, _, _),
    Weight =< Capacity.

% Helper predicate to check job 

check_job(DeliveryPersonID, Status):-
    (Status == no_job ->
        delivery_person(DeliveryPersonID, _, _, JOB, _),
        JOB == no_job
    ;
        true
    ).








