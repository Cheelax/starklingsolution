// move_semantics2.cairo
// Make me compile without changing line 16 or moving line 13!
// Execute `starklings hint move_semantics2` or use the `hint` watch subcommand for a hint.

use array::ArrayTrait;
use debug::PrintTrait;
//use clone::Clone;
//use array::ArrayTCloneImpl;



fn main() {
    let mut arr0 = ArrayTrait::new();
    //let arr_clone = arr0.clone();
    

    fill_array(ref arr0);

    // Do not change the following line!
    arr0.print();
}

// fn fill_array(arr: Array<felt252>) -> Array<felt252> {
//     let mut arr = arr;
// 
//     arr.append(22);
//     arr.append(44);
//     arr.append(66);
// 
//     arr
// }

fn fill_array(ref arr: Array<felt252>)  {

    arr.append(22);
    arr.append(44);
    arr.append(66);

}


//First solution is to add:
//use clone::Clone;
//use array::ArrayTCloneImpl;
// then:  let arr_clone = arr0.clone();
// and:  let arr1 = fill_array(arr_clone);

//Second solution is to modify arr0 as mut and pass "ref arr0" into the function call.
//Then, modify the function as follows:
//fn fill_array(ref arr: Array<felt252>)  {
//
//    arr.append(22);
//    arr.append(44);
//    arr.append(66);
//
//}