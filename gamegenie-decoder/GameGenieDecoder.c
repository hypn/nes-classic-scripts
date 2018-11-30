//Game Genie Decoder . Decodes 6 or 8 GameGenie code to its equivalent Address and value.
//Written by HaseeB Mir (haseebmir.hm@gmail.com)
//Dated : 22/02/2017
//Refrence by The Mighty Mike Master : http://tuxnes.sourceforge.net/gamegenie.html
//Thanks to Mighty Mike for his amazing refrence.

//Including Standard Libraries.
#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>

//Defining Length Constants.
#define MAX_GAME_GENIE_LEN 8 //Defining Max Length of GameGenie.
#define GAME_GENIE_TABLE_LEN 16 //MAX GameGenie Table Length.

//GameGenieCode subroutines.
void setGameGenieTable();
int checkGameGenieCode(char * );
int decodeGameGenieCode(char * );
int getGameGenieLen();

//subroutines for Address,value and Compare.
int decodeAddress();
int decodeValue();
int decodeCompare();

//Checking Invalid Input.
int isInvalidInput();

//Converting Input to UpperCase if needed.
_Bool isInputLower(char * str);
void toUpperCase(char * );

//GameGenie Code Table.
char GameGenieTable[GAME_GENIE_TABLE_LEN] = {
  'A', 'P', 'Z', 'L', 'G', 'I', 'T', 'Y',
  'E', 'O', 'X', 'U', 'K', 'S', 'V', 'N'
};

short n0, n1, n2, n3, n4, n5, n6, n7; //Contains HEX of GameGenieCode.
_Bool is_8_Char_GameGenie = false; //Checking for 8-Char GameGenie Code.

char * GameGenieCode; //Contains 6 or 8 Character GameGenieCode.

int main(int argc, char ** argv) {

  if (argc != 2) {
    printf("Usage:\n");
    printf("  %s <code>\n\n", argv[0]);
    return 1;
  }

  GameGenieCode = argv[1];

  //If Input is in lower Case convert it to Upper case.
  if (isInputLower(GameGenieCode)) {
    toUpperCase(GameGenieCode);
  }

  //Checking for 8-Character GameGenieCode.
  is_8_Char_GameGenie = (getGameGenieLen() == MAX_GAME_GENIE_LEN) ? true : false;

  if (decodeGameGenieCode(GameGenieCode)) {
    printf("0x%x %x", decodeAddress(), decodeValue()); //Prints Address in Hex.
  } else {
    printf("Not a Valid Game Genie Code\n\n");
    return 1;
  }

  return 0;
}

_Bool isInputLower(char * str) {
  int index = 0;

  for (index = 0; index < strlen(str); index++) {
    if (islower(str[index])) {
      return true;
    }
  }

  return false;
}

//Converts the Input to Capital case.
void toUpperCase(char * str) {
  int index = 0;
  char smallCase; //Hold small cases to compare

  while (str[index]) {
    //Check for All small characters.
    for (smallCase = 'a'; smallCase <= 'z'; smallCase++) {
      if (str[index] == smallCase) {
        str[index] -= 32; // 32 is difference between Capital and Small character's ASCII.
      }
    }
    index++;
  }
}

//Get Length of GameGenie Code.
int getGameGenieLen() {
  return strlen(GameGenieCode);
}

//Checking Invalid Input.
int isInvalidInput() {
  if (getGameGenieLen() < 6) {
    return 1; //Return True if its invalid Input.
  }

  return 0; //Otherwise return false.
}

//Decodes Value from GameGenie Code.
int decodeAddress() {
  int address = 0x8000 +
    ((n3 & 7) << 12) |
    ((n5 & 7) << 8) | ((n4 & 8) << 8) |
    ((n2 & 7) << 4) | ((n1 & 8) << 4) |
    (n4 & 7) | (n3 & 8);

  return address;
}

//Decodes Value from 6 or 8-Char GameGenie Code.
int decodeValue() {
  int value;

  //Checking if it's 8-Char_GameGenie Code.
  (is_8_Char_GameGenie == true)

  //Value of 8-Char GameGenie.
  ?
  (value =
    ((n1 & 7) << 4) | ((n0 & 8) << 4) |
    (n0 & 7) | (n7 & 8))

  //Value of 6-Char GameGenie.
  :
  (value =
    ((n1 & 7) << 4) | ((n0 & 8) << 4) |
    (n0 & 7) | (n5 & 8));

  return value;
}

//Decodes Compare Value for 8-Char GameGenie Code.
int decodeCompare() {
  int compare =
    ((n7 & 7) << 4) | ((n6 & 8) << 4) |
    (n6 & 7) | (n5 & 8);

  return compare;
}

//Decodes GameGenie chars to its equivalent Hex.
int decodeGameGenieCode(char * GameGenieCode) {

  //Check for Invalid Input.
  if (isInvalidInput()) {
    return 0; //Return False for Invalid Input.
  }

  int i = 0, j = 0, found = 0;
  int GameGenieLen = getGameGenieLen();

  for (i = 0; i < GameGenieLen; i++) {
    for (j = 0; j < GAME_GENIE_TABLE_LEN; j++) {
      if (GameGenieCode[i] == GameGenieTable[j]) {
        found++;

        //Twirling Ternary operators to convert Game Genie to its equivalent Hex.
        (found == 1) ? n0 = j: (found == 2) ? n1 = j :
          (found == 3) ? n2 = j : (found == 4) ? n3 = j :
          (found == 5) ? n4 = j : (found == 6) ? n5 = j : j;

        (is_8_Char_GameGenie) ? (found == 7 ? n6 = j : found == 8 ? n7 = j : j) : j;
      }
    }
  }

  //Checking for Invalid Genie Codes.
  return (found == GameGenieLen) ? 1 : 0;
}
