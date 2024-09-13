import Bool "mo:base/Bool";
import Func "mo:base/Func";
import List "mo:base/List";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the structure for a shopping list item
  public type ShoppingItem = {
    id: Nat;
    description: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var shoppingList: [ShoppingItem] = [];
  stable var nextId: Nat = 0;

  // Function to add a new item to the shopping list
  public func addItem(description: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: ShoppingItem = {
      id;
      description;
      completed = false;
    };
    shoppingList := Array.append(shoppingList, [newItem]);
    id
  };

  // Function to delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let (newList, deleted) = Array.foldLeft<ShoppingItem, ([ShoppingItem], Bool)>(
      shoppingList,
      ([], false),
      func (acc, item) {
        if (item.id == id) {
          (acc.0, true)
        } else {
          (Array.append(acc.0, [item]), acc.1)
        }
      }
    );
    shoppingList := newList;
    deleted
  };

  // Function to toggle the completion status of an item
  public func toggleCompleted(id: Nat) : async Bool {
    shoppingList := Array.map(shoppingList, func (item: ShoppingItem) : ShoppingItem {
      if (item.id == id) {
        {
          id = item.id;
          description = item.description;
          completed = not item.completed;
        }
      } else {
        item
      }
    });
    true
  };

  // Query function to get all items
  public query func getItems() : async [ShoppingItem] {
    shoppingList
  };
}