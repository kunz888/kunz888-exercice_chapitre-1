// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

contract Distributor {
 
    constructor()  {
        createItem() ;
        createRaw();
    }


    uint256 public constant item_quantity = 9;
    uint256 public constant item_limit = 15;
   
    // Faire une fonction capable de donner XX ice_tea a un utilisateur dans son inventaire
 
    // Faire une fonction pour recharger la quantite d'ice_tea
    // la fonction ne dois pas pouvoir depasser la limite max (cf: revert)

    // Rendre la fonction pour donner des ice_tea payable: voir le mot cle payable et msg.value et msg.sender
      struct Item{
     string name;
     uint256 price;
    
    }
    struct Raw{
        uint256 qty;
        Item item;
    }
    struct Customer{
        address addr;
        bool exist;
        uint256 IceTea;
        uint256 Mars;
        uint256 Lion;
        uint256 Fanta;
        uint256 Coca;

   }
    enum listItem {Ice_Tea,Mars,Lion,Fanta,Coca}

    Item[] public ListItem;
   
    

     mapping(string=> Raw) public MappingRaw;
    mapping(address=> Customer) public MappingCustomer;
   
    function getMappingRaw(string memory _name) public view returns (Raw memory) {
    return MappingRaw[_name];
    }
    function setMappingRaw(string memory _name, Raw memory value) public {
        MappingRaw[_name]=value;
    }

     //Mapping Customer
     function getMappingCustomer(address _key) public view returns (Customer memory) {
    return MappingCustomer[_key];
    }
      function setMappingCustomer(address _key,Customer memory value) public {
        MappingCustomer[_key]=value;
    }
      //creation des item
     //createListItem de depart
    function createItem() public{
        addItem("Ice_Tea", 1) ;
        addItem("Mars", 2); 
        addItem("Lion", 2) ;
        addItem("Fanta", 1) ;
        addItem("Coca", 1) ;
    }

//add item
    function addItem(string memory _name, uint256 _price) public {
       Item memory it=Item(_name, _price);
      
       //ajoute au tableau un nouvel article avec son prix
       ListItem.push(it);
       //ajoute simultanément au mapping
       addRaw(it, item_quantity) ;
    }
//remove item
   function removeItem(uint256 _index) public {
       ListItem[_index] = ListItem[ListItem.length - 1];
       ListItem.pop();
    }
    //create Raw
         //createListItem
    function createRaw() public{
        addRaw(ListItem[0], item_quantity) ;
        addRaw(ListItem[1], item_quantity) ;
        addRaw(ListItem[2], item_quantity) ;
        addRaw(ListItem[3], item_quantity) ;
        addRaw(ListItem[4], item_quantity) ;
  
    }

//add item
    function addRaw(Item memory _article,uint256 _qty) public {
       Raw memory r=Raw(_qty,_article);
      setMappingRaw(_article.name,r);
    }
     //recharge item , remplissage automatique 
   function rechargeItem(string memory _articleName) public {
    Raw memory r;
    r=getMappingRaw(_articleName);
    if(r.qty<=item_quantity)
    {
      r.qty=item_limit;
    }
    MappingRaw[_articleName]=r;
   }
   //recharge item , remplissage automatique 
   function rechargeItemAuto(string memory _articleName,Raw memory r) public {
  
    if(r.qty<=item_quantity)
    {
      r.qty=item_limit;
    }
    MappingRaw[_articleName]=r;
   }
///return cost of the command and recharge item if <item normal qty
    function costItem(string memory _articleName,uint256 _nbItem) public   returns (uint256){
    
    uint256 price;
     Raw memory r;
    r=getMappingRaw(_articleName);

     rechargeItemAuto(_articleName,r);
   
    price=r.item.price*_nbItem;
    return price ;
    }
//return pay command

    function payItem(string memory _articleName,uint256 _nbItem) public  payable {
    uint256 price;
   
    price=costItem(_articleName,_nbItem);
    Raw memory r;
    r=getMappingRaw(_articleName);

 
    require(r.qty<item_limit,"Not enought product!!");
    require(msg.value>=price);


    
   
    r.qty=r.qty-_nbItem;
    MappingRaw[_articleName]=r;

   Customer memory cus;
   cus=getMappingCustomer(msg.sender);
   if(!cus.exist)
   {
    cus.addr=msg.sender;
    if(compareStrings(_articleName,"Ice_Tea"))
    {
     cus.IceTea=_nbItem;
    }
    if(compareStrings(_articleName,"Mars"))
    {
     cus.Mars=_nbItem;
    }
     if(compareStrings(_articleName,"Lion"))
    {
     cus.Lion=_nbItem;
    }
     if(compareStrings(_articleName,"Fanta"))
    {
     cus.Fanta=_nbItem;
    }
     if(compareStrings(_articleName,"Coca"))
    {
     cus.Coca=_nbItem;
    }
    cus.exist=true;
    setMappingCustomer(msg.sender,cus);
   }
   else 
   {
       uint256 t=cus.IceTea;
       uint256 m=cus.Mars;
       uint256 l=cus.Lion;
       uint256 f=cus.Fanta;
       uint256 c=cus.Coca;
   if(compareStrings(_articleName,"Ice_Tea"))
    {
     t+=_nbItem;
    }
    if(compareStrings(_articleName,"Mars"))
    {
     m+=_nbItem;
    }
     if(compareStrings(_articleName,"Lion"))
    {
     l+=_nbItem;
    }
     if(compareStrings(_articleName,"Fanta"))
    {
     f+=_nbItem;
    }
     if(compareStrings(_articleName,"Coca"))
    {
     c+=_nbItem;
    }
    cus.IceTea=t;
    cus.Mars=m;
    cus.Lion=l;
    cus.Fanta=f;
    cus.Coca=c;
    setMappingCustomer(msg.sender,cus);
    
    //rend la monnaiesi il y a
     withdRawEther(msg.value,price);
   }
}
    function withdRawEther(uint256 _sellerMoney,uint256 _price) public {
        uint256 _amountToReturn;
        if(_sellerMoney>_price)
        {
            _amountToReturn=_sellerMoney-_price;

        }
      bool sent = payable(msg.sender).send(_amountToReturn);
     require(sent, "send failed");
    }
//fonction de compare string
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}