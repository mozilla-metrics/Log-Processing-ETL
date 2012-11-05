Ingesting Firefox Mobile data from Android Developer Console exports
--------------------------------------------------------------------
This ETL parses and loads files into Vertica.

The ETL handles incremental updates with overlapping dates.
First, it checks whether the overlapping data is identical. If not, it reports the differences.
Then, it replaces the overlapping dates, and inserts the new data.

The following variable should be set before running the ETL:
FIREFOXMOBILE_INBOX : folder with the files to be imported

The main entry point is main.kjb

