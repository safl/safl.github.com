rsync
=====

.. literalinclude:: install-rsync.sh
   :language: bash
   :lines: 1-

Run::

  rsync -a -r <src>/ <dst>

* ``-a`` the archive option preserves file-properties etc.
* ``-r`` recursively, dive down into sub-directories

And when the transfer is interrupted then resume it with:

* ``-P``, enables ``--partial`` and ``--progress``
