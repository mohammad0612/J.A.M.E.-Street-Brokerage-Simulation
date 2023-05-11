exception NoSuchStock of string
exception Broke

let update_avg (a1, f1) (a2, f2) = ((a1 *. f1) +. (a2 *. f2)) /. (f1 +. f2)

let order lst =
  let sorted_lst =
    List.sort
      (fun ({ Account.ticker = s1; Account.price = a1 }, f1)
           ({ Account.ticker = s2; Account.price = a2 }, f2) ->
        String.compare s1 s2)
      lst
  in
  let rec combine_entries acc lst =
    match lst with
    | [] -> List.rev acc
    | [ ({ Account.ticker = s1; Account.price = a1 }, f1) ] ->
        List.rev (({ Account.ticker = s1; Account.price = a1 }, f1) :: acc)
    | ({ Account.ticker = s1; Account.price = a1 }, f1)
      :: ({ Account.ticker = s2; Account.price = a2 }, f2)
      :: tl ->
        if s1 = s2 then
          combine_entries
            (( {
                 Account.ticker = s1;
                 Account.price = update_avg (a1, f1) (a2, f2);
               },
               f1 +. f2 )
            :: acc)
            tl
        else
          combine_entries
            (({ Account.ticker = s1; Account.price = a1 }, f1) :: acc)
            (({ Account.ticker = s2; Account.price = a2 }, f2) :: tl)
  in
  combine_entries [] sorted_lst

let buy shares ticker acc =
  try
    let price = Stocks.get_ticker_price ticker in
    if shares *. price > (Account.withdraw 0. acc).cash_balance then raise Broke
    else
      let liquid = (Account.withdraw (shares *. price) acc).cash_balance in
      {
        Account.stock_balance = acc.stock_balance +. (shares *. price);
        Account.cash_balance = liquid;
        Account.portfolio = order (({ ticker; price }, shares) :: acc.portfolio);
        Account.watchlist = acc.watchlist;
      }
  with
  | Broke -> raise Broke
  | exc -> raise (NoSuchStock ticker)
