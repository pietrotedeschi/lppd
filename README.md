# UDCA: Privacy-Preserving Co-Location Detection for Unmanned Aerial Vehicles

## Formal verification with ProVerif
The security properties of ``UDCA`` have been verified formally and experimentally by using the open-source tool ProVerif 2.01, demonstrating enhanced security protection with respect to state-of-the-art approaches.

In order to test the security properties, download the file udca.pv and run: ./proverif udca.pv | grep "RESULT". Further, in order to verify that the location is a strong secret (i.e. the attacker cannot launch offline guessing attacks on the location value), please follow the guidelines inside the code.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
``UDCA`` is released under the GNU General Public License v3.0 license.
