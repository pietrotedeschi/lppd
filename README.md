# UDCA: Privacy-Preserving Co-Location Detection for Unmanned Aerial Vehicles

Our solution, namely ``UDCA``, allows two directly-connected UAV, in mutual radio visibility, to know if they are in proximity, i.e., at risk of immediate physical collision, without revealing their actual location.

<p align="center">
  <img src="https://github.com/pietrotedeschi/udca/blob/master/figures/scenario_udca.png" alt="UDCA" width="900">
</p>

The details are provided in the paper.

## Formal verification with ProVerif
The security properties of ``UDCA`` have been verified formally and experimentally by using the open-source tool ProVerif 2.02pl1, demonstrating enhanced security protection with respect to state-of-the-art approaches.

In order to test the security properties, download the file udca.pv and run: ./proverif udca.pv | grep "RESULT". Further, in order to verify that the location is a strong secret (i.e. the attacker cannot launch offline guessing attacks on the location value), please follow the guidelines inside the code.

<p align="center">
  <img src="https://github.com/pietrotedeschi/udca/blob/master/figures/proverif.png" alt="UDCA" width="800">
</p>

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
``UDCA`` is released under the GNU General Public License v3.0 license.
