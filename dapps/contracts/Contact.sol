// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract Contact {
    uint256 private contactCounter = 0;

    struct ContactModel {
        uint256 id;
        string name;
        string email;
        address created_by;
        uint256 created_at;
        uint256 updated_at;
    }

    ContactModel[] contacts;

    function createContact(
        string calldata name,
        string calldata email
    ) external returns (bool) {
        require(bytes(name).length > 0, "name cannot be empty.");
        require(bytes(email).length > 0, "email cannot be empty.");

        contactCounter++;

        contacts.push(
            ContactModel(
                contactCounter,
                name,
                email,
                msg.sender,
                block.timestamp,
                block.timestamp
            )
        );

        return true;
    }

    function updateContact(
        uint256 id,
        string calldata name,
        string calldata email
    ) external returns (bool) {
        require(bytes(name).length > 0, "name cannot be empty.");
        require(bytes(email).length > 0, "email cannot be empty.");

        for (uint i = 0; i < contacts.length; i++) {
            if (contacts[i].id == id) {
                contacts[i].name = name;
                contacts[i].email = email;

                return true;
            }
        }

        return false;
    }

    function deleteContact(uint256 id) external returns (bool) {
        for (uint i = 0; i < contacts.length; i++) {
            if (contacts[i].id == id) {
                delete contacts[i];

                return true;
            }
        }

        return false;
    }

    function allContacts() external view returns (ContactModel[] memory) {
        return contacts;
    }

}