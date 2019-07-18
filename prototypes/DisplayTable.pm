package DisplayTable;
use strict;
use warnings; 
use Perl6::Say;
use Carp 'croak';
use English;
our $VERSION = '1.00';
use Try::Tiny;
use Ouch;
use lib 'lib';
use DBIx::Class::Storage::TxnScopeGuard;
use Getopt::Long;
use Data::Table;

use Up::Schema;
use MyConfig 'GetDSNinfo';


# is the file called as a program or a module method???
script() if not caller();


# validate arguments to program and call the main body
sub script {
#   say 'called as script';

   my $file_id;
   my $help=0;

   GetOptions ( "file=i" => \$file_id,    
                "help"   => \$help)
      or croak("Error in command line arguments");

   if ( ($help) or (not defined $file_id) ) {
      print STDOUT <<EOM;

      Usage Display.pm [-h] [-f file_id ]
        -h: this help message
        -f: file_id of upload

      example: Display.pm -f 1
EOM
      exit 0;
   }

   my ($dsn,$u,$p) = MyConfig->GetDSNinfo();
   my $db  = Up::Schema->connect($dsn,$u,$p,);

   mymain($file_id,$db);

   exit 0;
}

# file used as a module with method 'perform'
sub perform {
#   say 'perform';
   my ($file_id, $db) = shift;
   mymain($file_id,$db);
   return 1;
}


# main body of the program whether called as a program or a module method
sub mymain {
#   say 'mymain';
   my ($fn,$this) = @_;
   my (@rows,@columns);

   my $file_id = 1;
   my ($guard, @wrksheet, $txt);
      @wrksheet = $this->db->resultset('Datasheet')->search(
         {  file_id  =>  $file_id,
         },
         {  columns  => [qw/ sheet_id sheet_name/],
            order_by => [qw/ sheet_id /],
         },
      );
      for my $sheet (@wrksheet) {
         $txt .= "<br></br><h3>" . $sheet->sheet_name . "</h3><br></br>";
         my @data = $this->db->resultset('Data')->search(
            {  file_id  =>  $file_id,
               sheet_id =>  $sheet->sheet_id,
            },
            {  order_by => [qw/ row_id /],
            },
         );
         my $header;
         my $matrix = [];
         my $r = 0;
         my @row;
         for my $d (@data) {
           if ($r != $d->row_indx) {
              say "next row";
              push @{$matrix}, [@row];
              @row=();
              $r++;
           } 
           push @row, $d->field;
         }

         if (scalar @row) { push @$matrix, [@row]; }
         $header = shift @$matrix;
         
         # create html table
         #    $type=0, consider $data as the rows of the table.
         my $t = Data::Table->new($matrix, $header, 0);  
         $txt .= $t->html() . '<br></br>' .
                 qq(<a href="/">Upload Menu</a><br></br>);
      }
      return $txt;
}
1;
__END__
