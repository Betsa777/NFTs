//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    /***errors***/
    error MoodNft__CantFlipMoodIfNotOwner();
    uint256 private s_tokenCounter;
    /*correspond au fichier svg correspondant à l'image sad convertie en base64 
     avec base64 -i sad.svg puis auquel on ajoute au debut le baseUri qui est
     data:image/svg+xml;base64
    */

    string private s_sadSvgImageToUri;
    string private s_happySvgSvgImageToUri;

    enum Mood {
        HAPPY,
        SAD
    }
    //a partir de l'id du token on retrouve son mood soit happy ou sad
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageToUri,
        string memory happySvgSvgImageToUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageToUri = sadSvgImageToUri;
        s_happySvgSvgImageToUri = happySvgSvgImageToUri;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    //change the mood
    function flipMood(uint256 tokenId) public {
        //we only want the nft owner to be able to change the mood
        //getApproved Returns the approved address for `tokenId
        //ownerOf retruns the owner of the toekenId
        //they come from ERC721.sol
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happySvgSvgImageToUri;
        } else {
            imageUri = s_sadSvgImageToUri;
        }
        /*abi.encodePacked est utilisée pour encoder plusieurs arguments 
        en une seule chaîne de bytes (bytes array) compacte*/
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '","description": "a nft that reflects the mood", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                            imageUri,
                            '"}'
                        )
                    )
                )
            );
    }
}
